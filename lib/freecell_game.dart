import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'card.dart';
import 'components/playing_card.dart';
import 'game_state.dart';

class FreecellGame extends FlameGame {
  final gameState = GameState();

  static const padding = 10;

  get width => size.x / 10;

  @override
  Color backgroundColor() => Colors.green;

  Vector2 columnPos(int column, int row) => Vector2(padding + (width + padding) * column as double, 50 + row * 50);

  @override
  Future<void> onLoad() async {
    final tableau = gameState.board.tableau;
    tableau.asMap().forEach((x, cards) {
      cards.asMap().forEach((y, card) {
        add(
          PlayingCard(
            card: card,
            position: columnPos(x, y),
            size: Vector2(width, width * 1.6),
            onTap: (Card card) => gameState.onTap(card),
          ),
        );
      });
    });
  }
}

// return Scaffold(
//   backgroundColor: Colors.green,
//   appBar: AppBar(
//       centerTitle: true,
//       title: SizedBox(
//         width: 100,
//         child: TextField(
//           controller: TextEditingController()..text = board.seed.toString(),
//           decoration: const InputDecoration(border: UnderlineInputBorder(), prefixText: "#"),
//           keyboardType: TextInputType.number,
//           onSubmitted: _onChangeSeed,
//         ),
//       ),
//       leading: IconButton(icon: const Icon(Icons.autorenew), tooltip: "New game", onPressed: _newGame),
//       actions: [
//         IconButton(icon: const Icon(Icons.fast_rewind), tooltip: "Restart", onPressed: undoIndex == 0 ? null : _restart),
//         IconButton(
//           icon: const Icon(Icons.undo),
//           tooltip: "Undo",
//           onPressed: undoIndex == 0 ? null : _undo,
//         ),
//         IconButton(icon: const Icon(Icons.redo), tooltip: "Redo", onPressed: undoIndex == undoState.length - 1 ? null : _redo)
//       ]),
//   body: Center(
//     child: Board(board: board, onTap: _onTap),
//   ),
// );