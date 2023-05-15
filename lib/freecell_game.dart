import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:freecell/board_state.dart';
import 'package:freecell/card.dart';
import 'package:freecell/list_utils.dart';
import 'components/playing_card.dart';
import 'game_state.dart';

class FreecellGame extends FlameGame {
  final gameState = GameState();

  static const double padding = 10;

  get width => size.x / 10;

  get height => width * 1.6;

  @override
  Color backgroundColor() => Colors.green;

  Vector2 tableauPos(int column, int row) => Vector2(padding + (width + padding) * column, height + padding * 2 + row * height / 2);

  Vector2 freeCellPos(int column) => Vector2(padding + (width + padding / 2) * column, padding);

  Vector2 homeCellPos(int column) => Vector2(padding * 6.5 + width * 4 + (width + padding / 2) * column, padding);

  @override
  Future<void> onLoad() async {
    gameState.board.tableau.asMap().forEach((x, cards) {
      cards.asMap().forEach((y, card) {
        add(
          PlayingCard(
            rankSuite: card.toString(),
            position: tableauPos(x, y),
            size: Vector2(width, width * 1.6),
            onTap: () => handleTap(card),
          ),
        );
      });
    });
  }

  Future<void> handleTap(Card card) async {
    final startIndex = gameState.undoIndex;
    gameState.onTap(card);
    for (int i = startIndex; i < gameState.undoIndex; i++) {
      final board = gameState.undoStates[i + 1];
      final prevBoard = gameState.undoStates[i];
      moveDiff(board, prevBoard);
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  Vector2 findCard(Card card) {
    final freecell = findIndex(gameState.board.freeCells, (c) => card == c);
    if (freecell != null) return freeCellPos(freecell);
    for (int i = 0; i < 4; i++) {
      final homecell = findIndex(gameState.board.homeCells[i], (c) => card == c);
      if (homecell != null) return homeCellPos(i);
    }
    for (int i = 0; i < 8; i++) {
      final tab = findIndex(gameState.board.tableau[i], (c) => card == c);
      if (tab != null) return tableauPos(i, tab);
    }
    return Vector2(0, 0);
  }

  void moveDiff(BoardState board, BoardState prevBoard) {
    for (int col = 0; col < 8; col++) {
      prevBoard.tableau[col].asMap().forEach((i, prevCard) {
        final card = board.tableau[col].elementAtOrNull(i);
        if (card != prevCard) {
          final playingCard = children.whereType<PlayingCard>().firstWhere((card) => card.toString() == prevCard.toString());
          final Vector2? pos = findCard(prevCard);
          playingCard.moveTo(pos ?? Vector2(0, 0));
        }
      });
    }
  }
}

// IconButton(icon: const Icon(Icons.autorenew), tooltip: "New game", onPressed: _newGame),
// TextField(
//   controller: TextEditingController()..text = board.seed.toString(),
//   decoration: const InputDecoration(border: UnderlineInputBorder(), prefixText: "#"),
//   keyboardType: TextInputType.number,
//   onSubmitted: _onChangeSeed,
// ),
// IconButton(icon: const Icon(Icons.fast_rewind), tooltip: "Restart", onPressed: undoIndex == 0 ? null : _restart),
// IconButton(
//   icon: const Icon(Icons.undo),
//   tooltip: "Undo",
//   onPressed: undoIndex == 0 ? null : _undo,
// ),
// IconButton(icon: const Icon(Icons.redo), tooltip: "Redo", onPressed: undoIndex == undoState.length - 1 ? null : _redo)