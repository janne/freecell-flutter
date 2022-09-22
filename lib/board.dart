import 'package:flutter/foundation.dart';
import 'package:freecell/card.dart';
import 'package:freecell/deck.dart';
import 'package:freecell/lists.dart';

typedef BoardFn = Board Function(Board);

@immutable
class Board {
  final int seed;
  final List<Card?> freeCells;
  final List<List<Card>> homeCells;
  final List<List<Card>> tableau;

  const Board({required this.seed, required this.freeCells, required this.homeCells, required this.tableau});

  factory Board.withSeed(int seed) {
    final List<Card?> freeCells = List.generate(4, (_) => null);
    final tableau = List.generate(8, (_) => <Card>[]);
    for (final entry in Deck.shuffled(seed).cards.asMap().entries) {
      tableau[entry.key % 8].add(entry.value);
    }
    final homeCells = List.generate(4, (_) => <Card>[]);
    return Board(seed: seed, freeCells: freeCells, tableau: tableau, homeCells: homeCells);
  }

  Board copyWith({
    int? seed,
    List<List<Card>>? tableau,
    List<List<Card>>? homeCells,
    List<Card?>? freeCells,
  }) =>
      Board(
        seed: seed ?? this.seed,
        freeCells: freeCells ?? this.freeCells,
        homeCells: homeCells ?? this.homeCells,
        tableau: tableau ?? this.tableau,
      );

  Board removeCard(Card card) => copyWith(
        tableau: tableau.map((stack) => stack.where((c) => c != card).toList()).toList(),
        homeCells: homeCells.map((stack) => stack.where((c) => c != card).toList()).toList(),
        freeCells: freeCells.map((c) => c == card ? null : c).toList(),
      );

  BoardFn? moveCardToHomeCell(Card card) {
    if (card.rank == "A") {
      final index = findIndex(homeCells, (column) => column.isEmpty);
      if (index != null) {
        return (Board board) => board.copyWith(homeCells: pushToIndex(board.homeCells, card, index));
      }
    }

    final index = findIndex(homeCells, (column) {
      if (column.isEmpty) return false;
      return column.last.suit == card.suit && column.last.nextRank == card.rank;
    });
    if (index != null) {
      return (Board board) => board.copyWith(homeCells: pushToIndex(board.homeCells, card, index));
    }

    return null;
  }

  BoardFn? moveCardToTableau(Card card) {
    final index = findIndex(tableau, (column) {
      if (column.isEmpty) return false;
      final lastCard = column.last;
      return lastCard.isBlack != card.isBlack && lastCard.rank == card.nextRank;
    });
    if (index != null) {
      return (Board board) => board.copyWith(tableau: pushToIndex(tableau, card, index));
    }

    final indexEmpty = findIndex(tableau, (column) => column.isEmpty);
    if (indexEmpty != null) {
      return (Board board) => board.copyWith(tableau: pushToIndex(tableau, card, indexEmpty));
    }

    return null;
  }

  BoardFn? moveCardToFreeCell(Card card) {
    final index = findIndex(freeCells, (cell) => cell == null);

    if (index != null) {
      return (Board board) => board.copyWith(freeCells: setAtIndex(board.freeCells, card, index));
    }
    return null;
  }

  BoardFn? moveCard(Card card) => [moveCardToHomeCell, moveCardToTableau, moveCardToFreeCell].fold<BoardFn?>(null, (memo, fn) {
        if (memo != null) return memo;
        return fn(card);
      });
}
