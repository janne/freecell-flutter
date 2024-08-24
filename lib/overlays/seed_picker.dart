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
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  void _submit() {
    if (_enteredSeed >= 1 && _enteredSeed <= 1000000) {
      widget.game.overlays.remove('seedPicker');
      widget.game.setGameSeed(_enteredSeed);
    }
  }

  void _cancel() {
    widget.game.overlays.remove('seedPicker');
  }

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
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Game number',
                ),
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _enteredSeed = int.tryParse(value) ?? 1;
                  });
                },
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cancel,
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Change'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
