import 'dart:math';

import 'package:flutter/material.dart' show immutable;

import '../utils/lists.dart';
import 'board.dart';
import 'card.dart';

@immutable
class Game {
  final int _seed;
  final List<Board> _boards;
  final int _boardIndex;

  const Game({required List<Board> boards, required int boardIndex, required int seed})
      : _boards = boards,
        _boardIndex = boardIndex,
        _seed = seed;

  Game copyWith({List<Board>? boards, int? boardIndex, int? seed}) => Game(
        boards: boards ?? _boards,
        boardIndex: boardIndex ?? _boardIndex,
        seed: seed ?? _seed,
      );

  static Game withSeed(int seed) => Game(boards: const [], boardIndex: -1, seed: seed).addBoard(Board.withSeed(seed));

  static Game random() => withSeed(Random().nextInt(1000000));

  int get seed => _seed;

  int get boardIndex => _boardIndex;

  Board get board => boards[_boardIndex];

  List<Board> get boards => _boards;

  Game addBoard(Board board, [skipAutoMove = false]) {
    final game = copyWith(
      boards: [...boards.getRange(0, _boardIndex + 1), board],
      boardIndex: _boardIndex + 1,
    );
    if (!skipAutoMove) return game.autoMove();
    return game;
  }

  Game restart() => copyWith(boardIndex: 0);

  Game undo() => copyWith(boardIndex: _boardIndex - 1);

  Game redo() => copyWith(boardIndex: _boardIndex + 1);

  Game autoMove() {
    final cardsToTest = <Card>[
      ...(board.freeCells.where((cell) => cell != null)).cast<Card>(),
      ...board.tableau.where((stack) => stack.isNotEmpty).map((stack) => stack.last)
    ];
    for (final card in cardsToTest) {
      final updateGame = board.moveCardToHomeCell(card);
      if (updateGame != null) {
        final updatedBoard = updateGame(board.removeCard(card));
        return addBoard(updatedBoard);
      }
    }
    return this;
  }

  int tapCount(Card card) {
    for (int col = 0; col < 8; col++) {
      final stack = board.tableau[col];
      final i = findIndex(stack, (c) => c == card);
      if (i != null) return stack.length - i;
    }
    return 1;
  }

  Game onTap(Card card) {
    final count = tapCount(card);
    if (count > 1) {
      final updateGame = board.moveCards(card, count);
      if (updateGame != null) {
        return addBoard(updateGame(board));
      }
      return this;
    }

    final updateGame = board.moveCard(card);
    if (updateGame != null) {
      final skipAutoMove = board.homeCells.any((cell) => cell.any((c) => c == card));
      return addBoard(updateGame(board.removeCard(card)), skipAutoMove);
    }
    return this;
  }

  Game next() => Game.withSeed(_seed + 1);

  Game previous() => Game.withSeed(_seed - 1);
}
