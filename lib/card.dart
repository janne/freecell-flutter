import 'package:flutter/foundation.dart';

enum Suit { clubs, diamonds, hearts, spades }

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

@immutable
class Card {
  final int _rank;
  final Suit _suit;

  const Card(this._rank, this._suit);

  String get suit {
    switch (_suit) {
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

  String get suitChar {
    switch (_suit) {
      case Suit.clubs:
        return "C";
      case Suit.diamonds:
        return "D";
      case Suit.hearts:
        return "H";
      case Suit.spades:
        return "S";
    }
  }

  get isBlack => _suit == Suit.clubs || _suit == Suit.spades;

  String get rank => _rankToString(_rank);

  String get nextRank => _rankToString(_rank + 1);

  String get svgFileName => "$rank$suitChar.svg";

  @override
  String toString() => "$rank$suit";
}
