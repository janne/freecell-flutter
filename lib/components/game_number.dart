import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class GameNumber extends TextComponent with TapCallbacks {
  final int _number;

  GameNumber(int number) : _number = number {
    textRenderer = TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 12));
    text = "#$_number";
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("TAP");
  }
}
