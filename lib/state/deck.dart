import 'card.dart';
import '../utils/generator.dart';

typedef Deck = List<Card>;

Deck _createDeck() => List.generate(13, (i) => i + 1)
    .map(
      (rank) => Suit.values.map(
        (suit) => (rank: rank, suit: suit),
      ),
    )
    .expand((v) => v)
    .toList();

Deck createShuffledDeck(int seed) {
  final generator = Generator(seed);
  final from = List.from(_createDeck(), growable: true);
  final Deck shuffledDeck = [];

  while (from.isNotEmpty) {
    final index = generator.next() % from.length;
    shuffledDeck.add(from.removeAt(index));
    if (index < from.length - 1) from.insert(index, from.removeLast());
  }
  return shuffledDeck;
}
