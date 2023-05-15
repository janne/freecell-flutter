import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart' show Curves;

import '../card.dart';

class PlayingCard extends SvgComponent with TapCallbacks, DragCallbacks {
  final Card _card;
  final Vector2 _origin;

  PlayingCard({required Vector2 position, required Card card, required Vector2 size})
      : _card = card,
        _origin = position,
        super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/${_card.svgFileName}');
  }

  @override
  void onTapDown(TapDownEvent event) {
    print(_card);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.delta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    add(MoveEffect.to(_origin, EffectController(duration: 0.3, curve: Curves.easeInOutSine)));
    super.onDragEnd(event);
  }
}
