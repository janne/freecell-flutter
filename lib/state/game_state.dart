import 'dart:math';

import 'package:flutter/foundation.dart';

import '../utils/lists.dart';
import 'board_state.dart';
import 'card.dart';

class GameState {
  BoardState board = BoardState.withSeed(Random().nextInt(1000000));
  List<BoardState> undoStates = [];
  int undoIndex = -1;

  GameState() {
    _addUndoState();
  }

  _addUndoState([skipAutoMove = false]) {
    undoStates = [...undoStates.getRange(0, undoIndex + 1), board];
    undoIndex = undoStates.length - 1;
    if (!skipAutoMove) autoMove();
  }

  restart() {
    undoIndex = 0;
    board = undoStates[undoIndex];
  }

  undo() {
    undoIndex -= 1;
    board = undoStates[undoIndex];
  }

  redo() {
    undoIndex += 1;
    board = undoStates[undoIndex];
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

  int tapCount(Card card) {
    for (int col = 0; col < 8; col++) {
      final stack = board.tableau[col];
      final i = findIndex(stack, (c) => c == card);
      if (i != null) return stack.length - i;
    }
    return 1;
  }

  void onTap(Card card) {
    final count = tapCount(card);
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
    undoStates = [];
    undoIndex = -1;
    _addUndoState();
  }
}
