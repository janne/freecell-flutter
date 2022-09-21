import 'package:flutter/material.dart';
import 'package:freecell/card.dart' as fc;

class PlayingCard extends StatelessWidget {
  final fc.Card card;
  final Function(fc.Card card) onTap;

  const PlayingCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 88,
      child: InkWell(
          onTap: () => onTap(card),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(card.toString()),
            ),
          )),
    );
  }
}
