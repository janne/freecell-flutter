import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class GameNumber extends TextComponent with TapCallbacks {
  final int _number;
  final void Function() onTap;

  GameNumber(int number, this.onTap) : _number = number {
    textRenderer = TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 24, fontWeight: FontWeight.bold));
    text = "#$_number";
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
