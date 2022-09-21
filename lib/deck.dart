import 'package:freecell/card.dart';
import 'package:freecell/generator.dart';

class Deck {
  final List<Card> cards;

  Deck(this.cards);

  factory Deck.full() {
    return Deck(
        Suit.values.map((suit) => List.generate(13, (rank) => Rank(rank + 1)).map((rank) => Card(rank: rank, suit: suit))).expand((v) => v).toList());
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
