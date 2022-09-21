enum Suit { clubs, diamonds, hearts, spades }

class Rank {
  final int _rank;

  Rank(this._rank);

  @override
  String toString() {
    switch (_rank) {
      case 1:
        return "A";
      case 11:
        return "J";
      case 12:
        return "Q";
      case 13:
        return "K";
      default:
        return _rank.toString();
    }
  }
}

class Card {
  Rank rank;
  Suit suit;

  Card({required this.rank, required this.suit});

  String get suitChar {
    switch (suit) {
      case Suit.clubs:
        return "♣";
      case Suit.diamonds:
        return "♦";
      case Suit.hearts:
        return "♥";
      case Suit.spades:
        return "♠";
    }
  }

  @override
  String toString() {
    return "$rank$suitChar";
  }
}
