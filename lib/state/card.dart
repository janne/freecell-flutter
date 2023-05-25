enum Suit { clubs, diamonds, hearts, spades }

typedef Card = ({int rank, Suit suit});

String _rankToString(int rank) {
  switch (rank) {
    case 1:
      return "A";
    case 11:
      return "J";
    case 12:
      return "Q";
    case 13:
      return "K";
    default:
      return rank.toString();
  }
}

String _suitToString(Suit suit) {
  switch (suit) {
    case (Suit.clubs):
      return "C";
    case (Suit.diamonds):
      return "D";
    case (Suit.hearts):
      return "H";
    case (Suit.spades):
      return "S";
  }
}

String cardToString(Card card) => "${_rankToString(card.rank)}${_suitToString(card.suit)}";

bool _isBlack(Card card) => card.suit == Suit.clubs || card.suit == Suit.spades;

bool _consecutiveCards(Card first, Card second) => first.rank + 1 == second.rank;

bool followingCards(Card first, Card second) => _consecutiveCards(first, second) && first.suit == second.suit;

bool alternatingCards(Card first, Card second) => _consecutiveCards(first, second) && _isBlack(first) != _isBlack(second);
