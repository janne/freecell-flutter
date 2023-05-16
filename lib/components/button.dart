import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';

class Button extends SvgComponent with TapCallbacks {
  final String icon;
  final Function onTap;

  Button({required Vector2 position, required this.icon, required this.onTap}) : super(position: position, size: Vector2(78, 64));

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  Future<void> onLoad() async {
    svg = await Svg.load('images/ui/$icon.svg');
  }
}
