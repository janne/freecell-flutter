import 'package:flutter/material.dart';
import 'package:freecell/card.dart' as fc;

class PlayingCard extends StatelessWidget {
  final fc.Card card;

  const PlayingCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 88,
      child: InkWell(
          onTap: () {
            print("Clicked $card");
          },
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
