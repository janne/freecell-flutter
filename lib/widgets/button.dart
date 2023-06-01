import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../main.dart';

class Button extends StatelessWidget {
  final String icon;
  final void Function() onTap;
  final Widget svg;

  Button({super.key, required Vector2 position, required this.icon, required this.onTap})
      : svg = SvgPicture.asset('images/ui/$icon.svg', semanticsLabel: icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        height: 78,
        child: svg,
      ),
    );
  }
}
