import 'dart:math';

import 'package:flutter/foundation.dart';

import '../utils/lists.dart';
import 'board_state.dart';
import 'card.dart';

class GameState {
  int seed = Random().nextInt(1000000);
  late BoardState board;
  List<BoardState> undoStates = [];
  int undoIndex = -1;

  GameState() {
    board = BoardState.withSeed(seed);
    addUndoState();
  }

  void addUndoState([skipAutoMove = false]) {
    undoStates = [...undoStates.getRange(0, undoIndex + 1), board];
    undoIndex = undoStates.length - 1;
    if (!skipAutoMove) _autoMove();
  }

  void restart() {
    undoIndex = 0;
    board = undoStates[undoIndex];
  }

  void undo() {
    undoIndex -= 1;
    board = undoStates[undoIndex];
  }

  void redo() {
    undoIndex += 1;
    board = undoStates[undoIndex];
  }

  void _autoMove() {
    final cardsToTest = <Card>[
      ...(board.freeCells.where((cell) => cell != null)).cast<Card>(),
      ...board.tableau.where((stack) => stack.isNotEmpty).map((stack) => stack.last)
    ];
    for (final card in cardsToTest) {
      final updateGame = board.moveCardToHomeCell(card);
      if (updateGame != null) {
        board = updateGame(board.removeCard(card));
        addUndoState();
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
        addUndoState();
      }
      return;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      final skipAutoMove = board.homeCells.any((cell) => cell.any((c) => c == card));
      board = updateGame(board.removeCard(card));
      addUndoState(skipAutoMove);
    }
  }

  void changeSeed(String value) {
    try {
      board = BoardState.withSeed(int.parse(value).clamp(0, 1000000));
    } catch (e) {
      if (kDebugMode) {
        print("Format exception: $value");
      }
    }
  }

  void prevGame() {}

  void nextGame() {}
}
