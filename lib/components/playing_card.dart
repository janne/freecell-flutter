import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/flame_svg.dart';

import '../card.dart';

class PlayingCard extends SvgComponent with TapCallbacks, DragCallbacks {
  final Card _card;
  final void Function(Card) _onTap;

  PlayingCard({required Vector2 position, required Card card, required Vector2 size, required void Function(Card) onTap})
      : _card = card,
        _onTap = onTap,
        super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/${_card.svgFileName}');
  }

  @override
  void onTapDown(TapDownEvent event) {
    _onTap(_card);
  }
}
