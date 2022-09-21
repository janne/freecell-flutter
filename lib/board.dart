import 'package:flutter/foundation.dart';
import 'package:freecell/card.dart';
import 'package:freecell/deck.dart';

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
    final homeCells = List.generate(8, (_) => <Card>[]);
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
}
