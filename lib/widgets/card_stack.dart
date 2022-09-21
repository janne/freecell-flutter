import 'package:flutter/widgets.dart';
import 'package:freecell/card.dart' as fc;
import 'package:freecell/widgets/playing_card.dart';

class CardStack extends StatelessWidget {
  final List<fc.Card> cards;

  const CardStack({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: cards
          .asMap()
          .map(
            (key, card) => MapEntry(
              key,
              Positioned(
                top: key * 35,
                child: PlayingCard(card: card),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
