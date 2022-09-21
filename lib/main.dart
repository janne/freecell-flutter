import 'package:flutter/material.dart';
import 'package:freecell/board.dart';
import 'package:freecell/card.dart' as fc;
import 'package:freecell/widgets/card_stack.dart';
import 'package:freecell/widgets/playing_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freecell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kungen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var board = Board.withSeed(1);

  void _onTap(fc.Card card) {
    setState(() {
      final tableau = board.tableau.map((stack) => stack.where((c) => c != card).toList()).toList();
      final homeCells = board.homeCells.map((stack) => stack.where((c) => c != card).toList()).toList();
      final freeCells = board.freeCells.map((c) => c == card ? null : c).toList();
      board = board.copyWith(tableau: tableau, freeCells: freeCells, homeCells: homeCells);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: Text(widget.title)),
      body: Row(
        children: board.tableau
            .map(
              (cards) => Expanded(child: CardStack(cards: cards, onTap: _onTap)),
            )
            .toList(),
      ),
    );
  }
}
