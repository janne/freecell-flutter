import 'package:flutter/material.dart';
import 'package:freecell/freecell_game.dart';

class SeedPicker extends StatefulWidget {
  final FreecellGame game; // Add game instance as a parameter
  const SeedPicker({super.key, required this.game});
  @override
  State<SeedPicker> createState() => _SeedPickerState();
}

class _SeedPickerState extends State<SeedPicker> {
  int _enteredSeed = 1; // Store the entered seed value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Prevent column from taking full height
            children: [
              const Text("Enter a game number (1 - 1 000 000)"),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _enteredSeed = int.tryParse(value) ?? 1;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_enteredSeed >= 1 && _enteredSeed <= 1000000) {
                    widget.game.overlays.remove('seedPicker');
                    widget.game.setGameSeed(_enteredSeed);
                  }
                },
                child: const Text('Change'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
