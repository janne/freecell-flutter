import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:freecell/freecell_game.dart';

void main() {
  final game = FreecellGame();
  runApp(GameWidget(game: game));
}
