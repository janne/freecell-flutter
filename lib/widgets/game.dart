import 'package:flutter/material.dart';
import 'package:freecell/board.dart';
import 'package:freecell/widgets/card_stack.dart';
import 'package:freecell/freecell.dart' as fc;
import 'package:freecell/widgets/playing_card.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var board = Board.withSeed(1);

  void _onTap(fc.Card card) {
    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      setState(() {
        board = updateGame(board.removeCard(card));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: const Text("Kungen")),
      body: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Row(
              children: board.freeCells
                  .map<Widget>(
                    (card) => card == null
                        ? const SizedBox(
                            width: 62,
                            height: 88,
                          )
                        : PlayingCard(
                            card: card,
                            onTap: _onTap,
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
                        ? const SizedBox(
                            width: 62,
                            height: 88,
                          )
                        : PlayingCard(
                            card: stack.last,
                            onTap: _onTap,
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
                  (cards) => Expanded(child: CardStack(cards: cards, onTap: _onTap)),
                )
                .toList(),
          ),
        )
      ]),
    );
  }
}
