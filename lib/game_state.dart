import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:freecell/freecell.dart';

class GameState {
  BoardState board = BoardState.withSeed(Random().nextInt(1000000));
  List<BoardState> undoState = [];
  int undoIndex = -1;

  GameState() {
    _addUndoState();
  }

  _addUndoState([skipAutoMove = false]) {
    undoState = [...undoState.getRange(0, undoIndex + 1), board];
    undoIndex = undoState.length - 1;
    if (!skipAutoMove) autoMove();
  }

  restart() {
    undoIndex = 0;
    board = undoState[undoIndex];
  }

  undo() {
    undoIndex -= 1;
    board = undoState[undoIndex];
  }

  redo() {
    undoIndex += 1;
    board = undoState[undoIndex];
  }

  autoMove() {
    final cardsToTest = <Card>[
      ...(board.freeCells.where((cell) => cell != null)).cast<Card>(),
      ...board.tableau.where((stack) => stack.isNotEmpty).map((stack) => stack.last)
    ];
    for (final card in cardsToTest) {
      final updateGame = board.moveCardToHomeCell(card);
      if (updateGame != null) {
        board = updateGame(board.removeCard(card));
        _addUndoState();
        break;
      }
    }
  }

  void onTap(Card card, [int count = 1]) {
    if (count > 1) {
      final updateGame = board.moveCards(card, count);
      if (updateGame != null) {
        board = updateGame(board);
        _addUndoState();
      }
      return;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      final skipAutoMove = board.homeCells.any((cell) => cell.any((c) => c == card));
      board = updateGame(board.removeCard(card));
      _addUndoState(skipAutoMove);
    }
  }

  changeSeed(String value) {
    try {
      board = BoardState.withSeed(int.parse(value).clamp(0, 1000000));
    } catch (e) {
      if (kDebugMode) {
        print("Format exception: $value");
      }
    }
  }

  newGame() {
    board = BoardState.withSeed(Random().nextInt(1000000));
    undoState = [];
    undoIndex = -1;
    _addUndoState();
  }
}
