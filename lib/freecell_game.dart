import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/playing_card.dart';

class FreecellGame extends FlameGame {
  @override
  Color backgroundColor() => Colors.green;

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < 8; i++) {
      final card = PlayingCard(card: "${i + 2}S", position: Vector2(110 * i + 10, 50));
      add(card);
    }
  }
}
