import 'package:flutter/material.dart';
import 'package:freecell/board.dart';
import 'package:freecell/card.dart' as Freecell;
import 'package:freecell/deck.dart';

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
  final board = Board(1);

  void _draw() {
    setState(() {
      // _deck.cards.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Row(
          children: board.tableau
              .map(
                (col) => Column(
                  children: col.map((card) => Text(card.toString())).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
