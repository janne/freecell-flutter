import 'package:flutter/material.dart';

class GameNumber extends StatelessWidget {
  final int _number;
  final void Function() onTap;

  const GameNumber(int number, this.onTap, {super.key}) : _number = number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text("#$_number", style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
