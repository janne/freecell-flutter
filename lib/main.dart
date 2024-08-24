import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'freecell_game.dart';
import 'overlays/seed_picker.dart';

void main() {
  final game = FreecellGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: GameWidget(
          game: game,
          overlayBuilderMap: {
            'seedPicker': (BuildContext context, FreecellGame game) {
              return SeedPicker(game: game);
            },
          },
        ),
      ),
    ),
  );
}
