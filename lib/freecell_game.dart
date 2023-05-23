import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart' show FlameGame;
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' show Color, Colors, TextStyle;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/button.dart';
import 'state/board.dart';
import 'state/card.dart';
import 'utils/lists.dart';
import 'components/playing_card.dart';
import 'state/game.dart';

final textRenderer = TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 12));

class FreecellGame extends FlameGame {
  int _prio = 0;

  late Game game;

  static const double padding = 4;
  static const double toolbarHeight = 64;

  double get maxWidth => (size.x - padding * 9) / 8;

  get width => min(maxWidth, 60);

  get height => width * 1.6;

  late TextComponent gameNumber;

  @override
  Color backgroundColor() => Colors.green;

  @override
  Future<void> onLoad() async {
    game = await getLastGame();
    game.boards[0].tableau.asMap().forEach((x, cards) {
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
    add(Button(position: Vector2(padding, padding), icon: "prev", onTap: _prev));
    add(Button(position: Vector2(padding + 78, padding), icon: "restart", onTap: _restart));
    add(Button(position: Vector2(padding + 78 * 2, padding), icon: "next", onTap: _next));
    add(Button(position: Vector2(padding + 78 * 3, padding), icon: "undo", onTap: _undo));
    add(Button(position: Vector2(padding + 78 * 4, padding), icon: "redo", onTap: _redo));
    gameNumber = TextComponent(text: "#${game.seed}", textRenderer: textRenderer);
    gameNumber.position = Vector2(size.x - gameNumber.size.x - 8, size.y - 20);
    add(gameNumber);

    await Future.delayed(const Duration(milliseconds: 500));
    _animateUndoStates(0);
  }

  Future<void> setLastGame(Game game) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastGame', game.seed);
  }

  Future<Game> getLastGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final seed = prefs.getInt('lastGame');
    final game = Game.withSeed(seed ?? 1);
    setLastGame(game);
    return game;
  }

  Vector2 _tableauPos(int column, int row) => Vector2(padding + (width + padding) * column, toolbarHeight + height + padding * 2 + row * height / 2);

  Vector2 _freeCellPos(int column) => Vector2(padding + (width + padding / 2) * column, padding + toolbarHeight);

  Vector2 _homeCellPos(int column) => Vector2(padding * 6.5 + width * 4 + (width + padding / 2) * column, padding + toolbarHeight);

  _prev() {
    if (PlayingCard.animating) return;
    final prevBoard = game.board;
    game = game.previous();
    _moveDiff(prevBoard, game.board, animateAll: true);
    gameNumber.text = "#${game.seed}";
    setLastGame(game);
  }

  _next() {
    if (PlayingCard.animating) return;
    final prevBoard = game.board;
    game = game.next();
    _moveDiff(prevBoard, game.board, animateAll: true);
    gameNumber.text = "#${game.seed}";
    setLastGame(game);
  }

  _undo() {
    if (game.boardIndex == 0 || PlayingCard.animating) return;
    game = game.undo();
    _moveDiff(game.boards[game.boardIndex + 1], game.board);
  }

  _redo() {
    if (game.boardIndex == game.boards.length - 1 || PlayingCard.animating) return;
    game = game.redo();
    _moveDiff(game.boards[game.boardIndex - 1], game.board);
  }

  _restart() {
    if (game.boardIndex == 0) return;
    final prevUndoIndex = game.boardIndex;
    game = game.restart();
    _moveDiff(game.boards[prevUndoIndex], game.board);
  }

  void _handleTap(Card card) {
    final startIndex = game.boardIndex;
    game = game.onTap(card);
    _animateUndoStates(startIndex);
  }

  Future<void> _animateUndoStates(int startIndex) async {
    for (int i = startIndex; i < game.boardIndex; i++) {
      final board = game.boards[i + 1];
      final prevBoard = game.boards[i];
      _moveDiff(prevBoard, board);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Vector2 _findCard(Card card) {
    // Freecells
    final freecell = findIndex(game.board.freeCells, (c) => card == c);
    if (freecell != null) return _freeCellPos(freecell);
    // Homecells
    for (int i = 0; i < 4; i++) {
      final homecell = findIndex(game.board.homeCells[i], (c) => card == c);
      if (homecell != null) return _homeCellPos(i);
    }
    // Tableau
    for (int i = 0; i < 8; i++) {
      final tab = findIndex(game.board.tableau[i], (c) => card == c);
      if (tab != null) return _tableauPos(i, tab);
    }
    return Vector2(0, 0);
  }

  void _moveDiff(Board prevBoard, Board board, {animateAll = false}) {
    // Freecells
    for (int col = 0; col < 4; col++) {
      final card = board.freeCells[col];
      if (card != null && (card != prevBoard.freeCells[col] || animateAll)) {
        _animateCard(card);
      }
    }
    // Homecells
    for (int col = 0; col < 4; col++) {
      board.homeCells[col].asMap().forEach((i, card) {
        if (card != prevBoard.homeCells[col].elementAtOrNull(i) || animateAll) {
          _animateCard(card);
        }
      });
    }
    // Tableau
    for (int col = 0; col < 8; col++) {
      board.tableau[col].asMap().forEach((i, card) {
        if (card != prevBoard.tableau[col].elementAtOrNull(i) || animateAll) {
          _animateCard(card);
        }
      });
    }
  }

  void _animateCard(Card card) {
    final playingCard = children.whereType<PlayingCard>().firstWhere((c) => c.toString() == card.toString());
    final Vector2 pos = _findCard(card);
    playingCard.priority = ++_prio;
    playingCard.moveTo(pos);
  }
}
