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

  @override
  Future<void> onLoad() async {
    final board = gameState.undoStates[0];
    board.tableau.asMap().forEach((x, cards) {
      cards.asMap().forEach((y, card) {
        add(
          PlayingCard(
            rankSuite: card.toString(),
            position: _tableauPos(x, y),
            size: Vector2(width, width * 1.6),
            onTap: () => _handleTap(card),
          ),
        );
      });
    });
    await Future.delayed(const Duration(milliseconds: 200));
    _animateUndoStates(0);
    add(Button(position: Vector2(padding, padding), icon: "prev", onTap: _prev));
    add(Button(position: Vector2(padding + 78, padding), icon: "restart", onTap: _restart));
    add(Button(position: Vector2(padding + 78 * 2, padding), icon: "next", onTap: _next));
    add(Button(position: Vector2(padding + 78 * 3, padding), icon: "undo", onTap: _undo));
    add(Button(position: Vector2(padding + 78 * 4, padding), icon: "redo", onTap: _redo));
  }

  Vector2 _tableauPos(int column, int row) => Vector2(padding + (width + padding) * column, toolbarHeight + height + padding * 2 + row * height / 2);

  Vector2 _freeCellPos(int column) => Vector2(padding + (width + padding / 2) * column, padding + toolbarHeight);

  Vector2 _homeCellPos(int column) => Vector2(padding * 6.5 + width * 4 + (width + padding / 2) * column, padding + toolbarHeight);

  _prev() {
    final prevBoard = gameState.board;
    gameState.prevGame();
    _moveDiff(prevBoard, gameState.board);
  }

  _next() {
    final prevBoard = gameState.board;
    gameState.nextGame();
    _moveDiff(prevBoard, gameState.board);
  }

  _undo() {
    if (gameState.undoIndex == 0) return;
    gameState.undo();
    _moveDiff(gameState.undoStates[gameState.undoIndex + 1], gameState.board);
  }

  _redo() {
    if (gameState.undoIndex == gameState.undoStates.length - 1) return;
    gameState.redo();
    _moveDiff(gameState.undoStates[gameState.undoIndex - 1], gameState.board);
  }

  _restart() {
    if (gameState.undoIndex == 0) return;
    final prevUndoIndex = gameState.undoIndex;
    gameState.undoIndex = 0;
    gameState.board = gameState.undoStates[0];
    _moveDiff(gameState.undoStates[prevUndoIndex], gameState.board);
  }

  void _handleTap(Card card) {
    final startIndex = gameState.undoIndex;
    gameState.onTap(card);
    _animateUndoStates(startIndex);
  }

  Future<void> _animateUndoStates(int startIndex) async {
    for (int i = startIndex; i < gameState.undoIndex; i++) {
      final board = gameState.undoStates[i + 1];
      final prevBoard = gameState.undoStates[i];
      _moveDiff(prevBoard, board);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Vector2 _findCard(Card card) {
    // Freecells
    final freecell = findIndex(gameState.board.freeCells, (c) => card == c);
    if (freecell != null) return _freeCellPos(freecell);
    // Homecells
    for (int i = 0; i < 4; i++) {
      final homecell = findIndex(gameState.board.homeCells[i], (c) => card == c);
      if (homecell != null) return _homeCellPos(i);
    }
    // Tableau
    for (int i = 0; i < 8; i++) {
      final tab = findIndex(gameState.board.tableau[i], (c) => card == c);
      if (tab != null) return _tableauPos(i, tab);
    }
    return Vector2(0, 0);
  }

  void _moveDiff(BoardState prevBoard, BoardState board) {
    // Freecells
    for (int col = 0; col < 4; col++) {
      final card = board.freeCells[col];
      if (card != null && card != prevBoard.freeCells[col]) {
        _animateCard(card);
      }
    }
    // Homecells
    for (int col = 0; col < 4; col++) {
      board.homeCells[col].asMap().forEach((i, card) {
        if (card != prevBoard.homeCells[col].elementAtOrNull(i)) {
          _animateCard(card);
        }
      });
    }
    // Tableau
    for (int col = 0; col < 8; col++) {
      board.tableau[col].asMap().forEach((i, card) {
        if (card != prevBoard.tableau[col].elementAtOrNull(i)) {
          _animateCard(card);
        }
      });
    }
  }

  void _animateCard(Card card) {
    final playingCard = children.whereType<PlayingCard>().firstWhere((c) => c.toString() == card.toString());
    final Vector2 pos = _findCard(card);
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