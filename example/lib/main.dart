
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shortcuts_display/shortcuts_display.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 25, 43),
      body: ShortcutsDisplay(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () {
            setState(() {
              count++;
            });
          },
          const SingleActivator(LogicalKeyboardKey.arrowDown): () {
            setState(() {
              count--;
            });
          },
          const SingleActivator(LogicalKeyboardKey.escape): () {
            setState(() {
              count--;
            });
          },
        },
        child: Center(
          child: Text(
            "$count",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
