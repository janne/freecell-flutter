import 'package:flutter/material.dart';
import 'package:freecell/widgets/playing_card.dart';
import 'package:freecell/widgets/playing_card_space.dart';
import 'package:freecell/freecell.dart' as fc;

import 'card_stack.dart';

class Board extends StatelessWidget {
  final fc.Board board;
  final void Function(fc.Card card, [int count]) onTap;

  const Board({super.key, required this.board, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Row(
              children: board.freeCells
                  .map<Widget>(
                    (card) => card == null
                        ? const PlayingCardSpace()
                        : PlayingCard(
                            card: card,
                            onTap: onTap,
                          ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: board.homeCells
                  .map<Widget>(
                    (stack) => stack.isEmpty
                        ? const PlayingCardSpace()
                        : PlayingCard(
                            card: stack.last,
                            onTap: onTap,
                          ),
                  )
                  .toList(),
            ),
            // Row(children: []),
          )
        ]),
        Expanded(
          child: Row(
            children: board.tableau
                .map(
                  (cards) => Expanded(child: CardStack(cards: cards, onTap: onTap)),
                )
                .toList(),
          ),
        )
      ]),
    );
  }
}
