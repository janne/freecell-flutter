import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/flame_svg.dart';

class PlayingCard extends SvgComponent with TapCallbacks {
  final String _card;

  PlayingCard({required Vector2 position, required String card})
      : _card = card,
        super(position: position, size: Vector2(100, 160));

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/$_card.svg');
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("Tapped card!");
  }
}
