import 'dart:math';

import 'package:flutter/foundation.dart';
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
  var board = Board.withSeed(Random().nextInt(1000000));

  void _onTap(fc.Card card, [int count = 1]) {
    if (count > 1) {
      final updateGame = board.moveCards(card, count);
      if (updateGame != null) {
        setState(() {
          board = updateGame(board);
        });
      }
      return;
    }

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
      appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
              width: 150,
              height: 50,
              child: TextField(
                controller: TextEditingController()..text = board.seed.toString(),
                decoration: const InputDecoration(border: UnderlineInputBorder(), prefixText: "#"),
                keyboardType: TextInputType.number,
                onSubmitted: (String value) {
                  setState(() {
                    try {
                      board = Board.withSeed(int.parse(value).clamp(0, 1000000));
                    } catch (e) {
                      if (kDebugMode) {
                        print("Format exception: $value");
                      }
                    }
                  });
                },
              )),
          leading: IconButton(
              icon: const Icon(Icons.autorenew),
              tooltip: "New game",
              onPressed: () {
                setState(() {
                  board = Board.withSeed(Random().nextInt(1000000));
                });
              }),
          actions: [
            IconButton(icon: const Icon(Icons.fast_rewind), tooltip: "Restart", onPressed: () {}),
            IconButton(icon: const Icon(Icons.undo), tooltip: "Undo", onPressed: () {}),
            IconButton(icon: const Icon(Icons.redo), tooltip: "Redo", onPressed: () {})
          ]),
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
