import 'dart:math';

import '../utils/lists.dart';
import 'board.dart';
import 'card.dart';

class Game {
  final int _seed;
  List<Board> boards = [];
  int currentBoardIndex = -1;

  Game([int? seed]) : _seed = seed ?? Random().nextInt(1000000) {
    addBoard(Board.withSeed(_seed));
  }

  int get seed => _seed;

  Board get board => boards[currentBoardIndex];

  void addBoard(Board board, [skipAutoMove = false]) {
    boards = [...boards.getRange(0, currentBoardIndex + 1), board];
    currentBoardIndex = boards.length - 1;
    if (!skipAutoMove) _autoMove();
  }

  void restart() {
    currentBoardIndex = 0;
  }

  void undo() {
    currentBoardIndex--;
  }

  void redo() {
    currentBoardIndex++;
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
        addBoard(updatedBoard);
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
        addBoard(updateGame(board));
      }
      return;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      final skipAutoMove = board.homeCells.any((cell) => cell.any((c) => c == card));
      addBoard(updateGame(board.removeCard(card)), skipAutoMove);
    }
  }
}
