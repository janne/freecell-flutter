import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../main.dart';

class PlayingCard extends StatelessWidget {
  final String rankSuite;
  final void Function() _onTap;
  final Vector2 _size;
  final Vector2 _position;
  final Widget _svg;

  PlayingCard({super.key, required Vector2 position, required this.rankSuite, required Vector2 size, required void Function() onTap})
      : _onTap = onTap,
        _size = size,
        _position = position,
        _svg = SvgPicture.asset('images/cards/$rankSuite.svg', semanticsLabel: rankSuite);

  String value() => rankSuite;

  @override
  Widget build(BuildContext context) {
    final (width, height) = _size;
    final (left, top) = _position;
    return AnimatedPositioned(
      left: left,
      top: top,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
          child: SizedBox(width: width, height: height, child: _svg),
          onTap: () {
            _onTap();
          }),
    );
  }
}
