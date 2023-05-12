import 'package:flutter/material.dart';

class PlayingCardSpace extends StatelessWidget {
  final Widget? child;

  const PlayingCardSpace({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 52, height: 73, child: child);
  }
}
