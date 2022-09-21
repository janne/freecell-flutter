import 'package:flutter/material.dart';
import 'package:freecell/board.dart';
import 'package:freecell/widgets/card_stack.dart';
import 'package:freecell/freecell.dart' as fc;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Game> {
  var board = Board.withSeed(1);

  void _onTap(fc.Card card) {
    setState(() {
      final tableau = board.tableau.map((stack) => stack.where((c) => c != card).toList()).toList();
      final homeCells = board.homeCells.map((stack) => stack.where((c) => c != card).toList()).toList();
      final freeCells = board.freeCells.map((c) => c == card ? null : c).toList();
      board = board.copyWith(tableau: tableau, freeCells: freeCells, homeCells: homeCells);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: const Text("Kungen")),
      body: Row(
        children: board.tableau
            .map(
              (cards) => Expanded(child: CardStack(cards: cards, onTap: _onTap)),
            )
            .toList(),
      ),
    );
  }
}
