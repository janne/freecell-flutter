import 'dart:math';

import '../utils/lists.dart';
import 'board_state.dart';
import 'card.dart';

class GameState {
  final int _seed;
  List<BoardState> undoStates = [];
  int undoIndex = -1;

  GameState([int? seed]) : _seed = seed ?? Random().nextInt(1000000) {
    addUndoState(BoardState.withSeed(_seed));
  }

  int get seed => _seed;

  BoardState get board => undoStates[undoIndex];

  void addUndoState(BoardState board, [skipAutoMove = false]) {
    undoStates = [...undoStates.getRange(0, undoIndex + 1), board];
    undoIndex = undoStates.length - 1;
    if (!skipAutoMove) _autoMove();
  }

  void restart() {
    undoIndex = 0;
  }

  void undo() {
    undoIndex -= 1;
  }

  void redo() {
    undoIndex += 1;
  }

  void _autoMove() {
    final cardsToTest = <Card>[
      ...(board.freeCells.where((cell) => cell != null)).cast<Card>(),
      ...board.tableau.where((stack) => stack.isNotEmpty).map((stack) => stack.last)
    ];
    for (final card in cardsToTest) {
      final updateGame = board.moveCardToHomeCell(card);
      if (updateGame != null) {
        final updatedBoard = updateGame(board.removeCard(card));
        addUndoState(updatedBoard);
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
        addUndoState(updateGame(board));
      }
      return;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      final skipAutoMove = board.homeCells.any((cell) => cell.any((c) => c == card));
      addUndoState(updateGame(board.removeCard(card)), skipAutoMove);
    }
  }
}
