import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../state/card.dart';
import '../state/game.dart';
import 'playing_card.dart';

class FreecellGame extends StatefulWidget {
  const FreecellGame({super.key});

  @override
  State<FreecellGame> createState() => _FreecellGameState();
}

class _FreecellGameState extends State<FreecellGame> {
  _FreecellGameState() {
    setupBoard();
  }

  Game? game;
  int gameNumber = 0;

  static const double gap = 4;
  static const double toolbarHeight = 64;

  Size get size => MediaQuery.of(context).size;
  double get maxWidth => (size.width - gap * 9) / 8;
  double get cardWidth => min(maxWidth, 60);
  double get cardHeight => cardWidth * 1.6;
  get paddingLeft => size.width / 2 - (cardWidth + gap) * 4 + gap / 2;

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return Container();
    }

    final List<PlayingCard> cards = [];

    // Tableau
    game!.boards[game!.boardIndex].tableau.asMap().forEach((col, stack) {
      stack.asMap().forEach((row, card) {
        final rankSuite = cardToString(card);
        cards.add(PlayingCard(
          rankSuite: rankSuite,
          position: _tableauPos(col, row),
          size: (cardWidth, cardWidth * 1.6),
          onTap: () => _handleTap(card),
        ));
      });
    });

    // Freecells
    game!.boards[game!.boardIndex].freeCells.asMap().forEach((col, card) {
      if (card != null) {
        cards.add(PlayingCard(
          rankSuite: cardToString(card),
          position: _freeCellPos(col),
          size: (cardWidth, cardWidth * 1.6),
          onTap: () => _handleTap(card),
        ));
      }
    });

    // Homecells
    game!.boards[game!.boardIndex].homeCells.asMap().forEach((col, stack) {
      if (stack.isNotEmpty) {
        for (var card in stack) {
          cards.add(PlayingCard(
            key: Key(cardToString(card)),
            rankSuite: cardToString(card),
            position: _homeCellPos(col),
            size: (cardWidth, cardWidth * 1.6),
            onTap: () => _handleTap(card),
          ));
        }
      }
    });

    return Container(
      color: Colors.green,
      child: Stack(
        children: cards,
      ),
    );
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

  Vector2 _tableauPos(int col, int row) => (paddingLeft + (cardWidth + gap) * col, toolbarHeight + cardHeight + gap * 2 + row * cardHeight / 2);

  Vector2 _freeCellPos(int column) => (paddingLeft + (cardWidth + gap / 2) * column, gap + toolbarHeight);

  Vector2 _homeCellPos(int column) => (paddingLeft + gap * 5.5 + cardWidth * 4 + (cardWidth + gap / 2) * column, gap + toolbarHeight);

  _prev() {
    if (game == null) return;
    setState(() {
      game = game!.previous();
    });
    setLastGame(game!);
  }

  _next() {
    setState(() {
      game = game!.next();
    });
    setLastGame(game!);
  }

  _undo() {
    if (game!.boardIndex == 0) return;
    setState(() {
      game = game!.undo();
    });
  }

  _redo() {
    if (game!.boardIndex == game!.boards.length - 1) return;
    setState(() {
      game = game!.redo();
    });
  }

  _restart() {
    if (game!.boardIndex == 0) return;
    setState(() {
      game = game!.restart();
    });
  }

  void _handleTap(Card card) {
    setState(() {
      game = game!.onTap(card);
    });
  }

  Future setupBoard() async {
    final lastGame = await getLastGame();
    setState(() {
      game = lastGame;
    });
  }
}
