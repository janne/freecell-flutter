import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Color, Colors;

import 'components/button.dart';
import 'state/board_state.dart';
import 'state/card.dart';
import 'utils/lists.dart';
import 'components/playing_card.dart';
import 'state/game_state.dart';

class FreecellGame extends FlameGame {
  int prio = 0;

  final gameState = GameState();

  static const double padding = 4;
  static const double toolbarHeight = 64;

  get width => (size.x - padding * 9) / 8;

  get height => width * 1.6;

  @override
  Color backgroundColor() => Colors.green;

  Vector2 tableauPos(int column, int row) => Vector2(padding + (width + padding) * column, toolbarHeight + height + padding * 2 + row * height / 2);

  Vector2 freeCellPos(int column) => Vector2(padding + (width + padding / 2) * column, padding + toolbarHeight);

  Vector2 homeCellPos(int column) => Vector2(padding * 6.5 + width * 4 + (width + padding / 2) * column, padding + toolbarHeight);

  @override
  Future<void> onLoad() async {
    final board = gameState.undoStates[0];
    board.tableau.asMap().forEach((x, cards) {
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
    await Future.delayed(const Duration(milliseconds: 500));
    animateUndoStates(0);
    add(Button(
        position: Vector2(padding, padding),
        icon: "prev",
        onTap: () {
          print("Prev");
        }));
    add(Button(
        position: Vector2(padding + 78, padding),
        icon: "restart",
        onTap: () {
          print("Restart");
        }));
    add(Button(
        position: Vector2(padding + 78 * 2, padding),
        icon: "next",
        onTap: () {
          print("Next");
        }));
    add(Button(
        position: Vector2(padding + 78 * 3, padding),
        icon: "undo",
        onTap: () {
          if (gameState.undoIndex == 0) return;
          gameState.undo();
          moveDiff(gameState.undoStates[gameState.undoIndex + 1], gameState.board);
        }));
    add(Button(
        position: Vector2(padding + 78 * 4, padding),
        icon: "redo",
        onTap: () {
          if (gameState.undoIndex == gameState.undoStates.length - 1) return;
          gameState.redo();
          moveDiff(gameState.undoStates[gameState.undoIndex - 1], gameState.board);
        }));
  }

  void handleTap(Card card) {
    final startIndex = gameState.undoIndex;
    gameState.onTap(card);
    animateUndoStates(startIndex);
  }

  Future<void> animateUndoStates(int startIndex) async {
    for (int i = startIndex; i < gameState.undoIndex; i++) {
      final board = gameState.undoStates[i + 1];
      final prevBoard = gameState.undoStates[i];
      moveDiff(prevBoard, board);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Vector2 findCard(Card card) {
    // Freecells
    final freecell = findIndex(gameState.board.freeCells, (c) => card == c);
    if (freecell != null) return freeCellPos(freecell);
    // Homecells
    for (int i = 0; i < 4; i++) {
      final homecell = findIndex(gameState.board.homeCells[i], (c) => card == c);
      if (homecell != null) return homeCellPos(i);
    }
    // Tableau
    for (int i = 0; i < 8; i++) {
      final tab = findIndex(gameState.board.tableau[i], (c) => card == c);
      if (tab != null) return tableauPos(i, tab);
    }
    return Vector2(0, 0);
  }

  void moveDiff(BoardState prevBoard, BoardState board) {
    // Freecells
    for (int col = 0; col < 4; col++) {
      final card = board.freeCells[col];
      if (card != null && card != prevBoard.freeCells[col]) {
        animateCard(card);
      }
    }
    // Homecells
    for (int col = 0; col < 4; col++) {
      board.homeCells[col].asMap().forEach((i, card) {
        if (card != prevBoard.homeCells[col].elementAtOrNull(i)) {
          animateCard(card);
        }
      });
    }
    // Tableau
    for (int col = 0; col < 8; col++) {
      board.tableau[col].asMap().forEach((i, card) {
        if (card != prevBoard.tableau[col].elementAtOrNull(i)) {
          animateCard(card);
        }
      });
    }
  }

  void animateCard(Card card) {
    final playingCard = children.whereType<PlayingCard>().firstWhere((c) => c.toString() == card.toString());
    final Vector2 pos = findCard(card);
    playingCard.priority = ++prio;
    playingCard.moveTo(pos);
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