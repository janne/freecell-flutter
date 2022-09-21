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
  }) {
    return Board(
        seed: seed ?? this.seed, freeCells: freeCells ?? this.freeCells, homeCells: homeCells ?? this.homeCells, tableau: tableau ?? this.tableau);
  }

  Board removeCard(Card card) {
    final tableau = this.tableau.map((stack) => stack.where((c) => c != card).toList()).toList();
    final homeCells = this.homeCells.map((stack) => stack.where((c) => c != card).toList()).toList();
    final freeCells = this.freeCells.map((c) => c == card ? null : c).toList();
    return copyWith(tableau: tableau, freeCells: freeCells, homeCells: homeCells);
  }

  BoardFn? addCardInHome(Card card) {
    return null;
  }

  BoardFn? addCardInStack(Card card) {
    return null;
  }

  BoardFn? addCardInFreeCell(Card card) {
    final index = findIndex((cell) => cell == null, freeCells);

    if (index != null) {
      return (Board board) => board.copyWith(freeCells: setAtIndex(card, index, freeCells));
    }
    return null;
  }

  BoardFn? moveCard(Card card) {
    return [addCardInHome, addCardInStack, addCardInFreeCell].fold<BoardFn?>(null, (memo, fn) {
      if (memo != null) return memo;
      return fn(card);
    });
  }
}
