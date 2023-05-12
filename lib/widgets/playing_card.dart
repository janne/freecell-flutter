import 'package:flutter/material.dart';
import 'package:freecell/freecell.dart' as fc;
import 'package:freecell/widgets/playing_card_space.dart';

class PlayingCard extends StatelessWidget {
  final fc.Card card;
  final Function(fc.Card card) onTap;

  Color get _color => card.isBlack ? Colors.black : Colors.red;

  const PlayingCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PlayingCardSpace(
      child: InkWell(
        onTap: () => onTap(card),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(card.suit, style: TextStyle(fontSize: 40, color: _color)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  card.rank,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _color,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
