import 'package:freecell/deck.dart';

import 'card.dart';

class Board {
  int seed;
  final List<Card?> freeCells = List.generate(4, (_) => null);
  final homeCells = List.generate(8, (_) => <Card>[]);
  late final List<List<Card>> tableau;

  Board(this.seed) {
    final List<List<Card>> tableau = List.generate(8, (_) => <Card>[]);
    for (final entry in Deck.shuffled(seed).cards.asMap().entries) {
      tableau[entry.key % 8].add(entry.value);
    }
    this.tableau = tableau;
  }
}
