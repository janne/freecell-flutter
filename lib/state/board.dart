import 'package:flutter/foundation.dart';

import 'card.dart';
import 'deck.dart';
import '../utils/lists.dart';

typedef BoardFn = Board Function(Board);

@immutable
class Board {
  final List<Card?> freeCells;
  final List<List<Card>> homeCells;
  final List<List<Card>> tableau;

  const Board({required this.freeCells, required this.homeCells, required this.tableau});

  factory Board.withSeed(int seed) {
    final List<Card?> freeCells = List.generate(4, (_) => null);
    final tableau = List.generate(8, (_) => <Card>[]);
    for (final entry in createShuffledDeck(seed).asMap().entries) {
      tableau[entry.key % 8].add(entry.value);
    }
    final homeCells = List.generate(4, (_) => <Card>[]);
    return Board(freeCells: freeCells, tableau: tableau, homeCells: homeCells);
  }

  Board copyWith({
    int? seed,
    List<List<Card>>? tableau,
    List<List<Card>>? homeCells,
    List<Card?>? freeCells,
  }) =>
      Board(
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
    if (card.rank == 1) {
      final index = findIndex(homeCells, (column) => column.isEmpty);
      if (index != null) {
        return (Board board) => board.copyWith(homeCells: pushToIndex(board.homeCells, card, index));
      }
    }

    final index = findIndex(homeCells, (column) {
      if (column.isEmpty) return false;
      return followingCards(column.last, card);
    });
    if (index != null) {
      return (Board board) => board.copyWith(homeCells: pushToIndex(board.homeCells, card, index));
    }

    return null;
  }

  BoardFn? moveCardToTableau(Card card) {
    final index = findIndex(tableau, (column) {
      if (column.isEmpty) return false;
      return alternatingCards(card, column.last);
    });
    if (index != null) {
      return (Board board) => board.copyWith(tableau: pushToIndex(board.tableau, card, index));
    }

    final indexEmpty = findIndex(tableau, (column) => column.isEmpty);
    if (indexEmpty != null) {
      return (Board board) => board.copyWith(tableau: pushToIndex(board.tableau, card, indexEmpty));
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

  BoardFn? moveCards(Card card, int count) {
    final holes = tableau.where((column) => column.isEmpty).length + freeCells.where((cell) => cell == null).length;

    if (count > holes + 1) return null;

    final column = findIndex(tableau, (column) => column.contains(card))!;
    final index = findIndex(tableau[column], (c) => c == card)!;
    final cards = tableau[column].getRange(index, index + count).toList();

    for (var i = 1; i < cards.length; i++) {
      if (!alternatingCards(cards[i], cards[i - 1])) return null;
    }

    final i = findIndex(tableau, (column) {
      if (column.isEmpty) return false;
      return alternatingCards(card, column.last);
    });

    if (i != null) {
      return (Board board) {
        final cards = board.tableau[column].getRange(index, index + count).toList();
        final tableau = cards.fold(board.tableau, (memo, card) => pushToIndex(memo, card, i));
        final tableauMinusCard = deleteFromIndex(tableau, column, index);
        return board.copyWith(tableau: tableauMinusCard);
      };
    }

    if (count > holes) return null;

    final j = findIndex(tableau, (column) => column.isEmpty);
    if (j != null) {
      return (Board board) {
        final cards = board.tableau[column].getRange(index, index + count).toList();
        final tableau = cards.fold(board.tableau, (memo, card) => pushToIndex(memo, card, j));
        return board.copyWith(tableau: deleteFromIndex(tableau, column, index));
      };
    }

    return null;
  }
}
