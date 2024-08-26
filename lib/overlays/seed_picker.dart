import 'package:flutter/material.dart';
import 'package:freecell/freecell_game.dart';

class SeedPicker extends StatefulWidget {
  final FreecellGame game;
  const SeedPicker({super.key, required this.game});
  @override
  State<SeedPicker> createState() => _SeedPickerState();
}

class _SeedPickerState extends State<SeedPicker> {
  late int _enteredSeed;
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    _enteredSeed = widget.game.game.seed;
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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent column from taking full height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Game number",
                style: textTheme.titleMedium,
              ),
              TextFormField(
                initialValue: widget.game.game.seed.toString(),
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _enteredSeed = int.tryParse(value) ?? 1;
                  });
                },
                onFieldSubmitted: (_) => _submit(),
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
