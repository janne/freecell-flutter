import 'package:flutter/material.dart';
import 'package:freecell/freecell.dart' as fc;

class PlayingCard extends StatelessWidget {
  final fc.Card card;
  final Function(fc.Card card) onTap;

  Color get _color => card.isBlack ? Colors.black : Colors.red;

  const PlayingCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62 * 2,
      height: 88 * 2,
      child: InkWell(
        onTap: () => onTap(card),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Text(
                  card.rank,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _color),
                ),
              ),
              Text(
                card.suit,
                style: TextStyle(fontSize: 48, color: _color),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
