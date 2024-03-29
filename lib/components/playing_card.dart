import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class PlayingCard extends SvgComponent with TapCallbacks, DragCallbacks {
  final String rankSuite;
  final void Function() _onTap;
  static int moving = 0;

  PlayingCard({required Vector2 position, required this.rankSuite, required Vector2 size, required void Function() onTap})
      : _onTap = onTap,
        super(position: position, size: size);

  @override
  String toString() => rankSuite;

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/$rankSuite.svg');
  }

  static bool get animating => moving > 0;

  @override
  void onTapDown(TapDownEvent event) {
    if (animating) return;
    _onTap();
  }

  void moveTo(Vector2 position) {
    moving++;
    add(MoveToEffect(
      position,
      EffectController(duration: 0.3, curve: Curves.easeInOut),
      onComplete: () => moving--,
    ));
  }
}
