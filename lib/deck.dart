import 'package:flutter/widgets.dart';
import 'package:freecell/card.dart';
import 'package:freecell/generator.dart';

@immutable
class Deck {
  final List<Card> cards;

  const Deck(this.cards);

  factory Deck.full() {
    return Deck(List.generate(13, (i) => i + 1)
        .map(
          (rank) => Suit.values.map(
            (suit) => Card(rank, suit),
          ),
        )
        .expand((v) => v)
        .toList());
  }

  Deck shuffle(int seed) {
    final generator = Generator(seed);
    final from = List.from(cards, growable: true);
    final List<Card> shuffledDeck = [];

    while (from.isNotEmpty) {
      final index = generator.next() % from.length;
      shuffledDeck.add(from.removeAt(index));
      if (index < from.length - 1) from.insert(index, from.removeLast());
    }
    return Deck(shuffledDeck);
  }

  @override
  String toString() {
    final cardList = cards.map((card) => card.toString()).join(", ");
    return "[$cardList]";
  }

  factory Deck.shuffled(int seed) => Deck.full().shuffle(seed);
}
