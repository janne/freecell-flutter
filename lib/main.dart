import 'package:flutter/material.dart';

import 'widgets/freecell_game.dart';

typedef Vector2 = (double, double);

void main() {
  runApp(
    const MaterialApp(home: FreecellGame()),
  );
}
