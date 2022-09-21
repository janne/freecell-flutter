import 'package:flutter/foundation.dart';

enum Suit { clubs, diamonds, hearts, spades }

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

  String get rank {
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

  @override
  String toString() {
    return "$rank$suit";
  }
}
