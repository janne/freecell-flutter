import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'freecell_game.dart';

void main() {
  final game = FreecellGame();
  runApp(
    SafeArea(
      child: GameWidget(game: game),
    ),
  );
}
