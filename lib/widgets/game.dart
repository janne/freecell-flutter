import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecell/freecell.dart' as fc;
import 'package:freecell/widgets/board.dart';
import 'package:freecell/widgets/playing_card_space.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var board = fc.Board.withSeed(Random().nextInt(1000000));
  List<fc.Board> undoState = [];
  int undoIndex = -1;

  @override
  void initState() {
    _addUndoState();
    super.initState();
  }

  _addUndoState() {
    setState(() {
      undoState = [...undoState.getRange(0, undoIndex + 1), board];
      undoIndex = undoState.length - 1;
    });
  }

  _restart() {
    setState(() {
      undoIndex = 0;
      board = undoState[undoIndex];
    });
  }

  _undo() {
    setState(() {
      undoIndex -= 1;
      board = undoState[undoIndex];
    });
  }

  _redo() {
    setState(() {
      undoIndex += 1;
      board = undoState[undoIndex];
    });
  }

  void _onTap(fc.Card card, [int count = 1]) {
    if (count > 1) {
      final updateGame = board.moveCards(card, count);
      if (updateGame != null) {
        setState(() {
          board = updateGame(board);
          _addUndoState();
        });
      }
      return;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      setState(() {
        board = updateGame(board.removeCard(card));
        _addUndoState();
      });
    }
  }

  _onChangeSeed(String value) {
    setState(() {
      try {
        board = fc.Board.withSeed(int.parse(value).clamp(0, 1000000));
      } catch (e) {
        if (kDebugMode) {
          print("Format exception: $value");
        }
      }
    });
  }

  _newGame() {
    setState(() {
      board = fc.Board.withSeed(Random().nextInt(1000000));
      undoState = [];
      undoIndex = -1;
      _addUndoState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
          centerTitle: true,
          title: PlayingCardSpace(
            child: TextField(
              controller: TextEditingController()..text = board.seed.toString(),
              decoration: const InputDecoration(border: UnderlineInputBorder(), prefixText: "#"),
              keyboardType: TextInputType.number,
              onSubmitted: _onChangeSeed,
            ),
          ),
          leading: IconButton(icon: const Icon(Icons.autorenew), tooltip: "New game", onPressed: _newGame),
          actions: [
            IconButton(icon: const Icon(Icons.fast_rewind), tooltip: "Restart", onPressed: undoIndex == 0 ? null : _restart),
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: "Undo",
              onPressed: undoIndex == 0 ? null : _undo,
            ),
            IconButton(icon: const Icon(Icons.redo), tooltip: "Redo", onPressed: undoIndex == undoState.length - 1 ? null : _redo)
          ]),
      body: Center(
        child: Board(board: board, onTap: _onTap),
      ),
    );
  }
}
