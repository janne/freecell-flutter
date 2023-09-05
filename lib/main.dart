import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'freecell_game.dart';
import 'overlays/seed_picker.dart';

void main() {
  final game = FreecellGame();
  runApp(
    SafeArea(
      child: GameWidget(
        game: game,
        overlayBuilderMap: {
          'seedPicker': (BuildContext context, FreecellGame game) {
            return const SeedPicker();
          },
        },
      ),
    ),
  );
}
