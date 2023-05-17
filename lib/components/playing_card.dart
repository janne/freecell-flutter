import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class PlayingCard extends SvgComponent with TapCallbacks, DragCallbacks {
  final String rankSuite;
  final void Function() _onTap;

  PlayingCard({required Vector2 position, required this.rankSuite, required Vector2 size, required void Function() onTap})
      : _onTap = onTap,
        super(position: position, size: size);

  @override
  String toString() => rankSuite;

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/$rankSuite.svg');
  }

  @override
  void onTapUp(TapUpEvent event) {
    _onTap();
  }

  void moveTo(Vector2 position) {
    add(MoveEffect.to(position, EffectController(duration: 0.5, curve: Curves.easeInOut)));
  }
}
