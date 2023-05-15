import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/flame_svg.dart';

class PlayingCard extends SvgComponent with TapCallbacks, DragCallbacks {
  final String _svgFileName;
  final void Function() _onTap;

  PlayingCard({required Vector2 position, required String svgFileName, required Vector2 size, required void Function() onTap})
      : _svgFileName = svgFileName,
        _onTap = onTap,
        super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/cards/$_svgFileName');
  }

  @override
  void onTapDown(TapDownEvent event) {
    _onTap();
  }
}
