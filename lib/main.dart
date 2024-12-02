import 'package:flutter/material.dart';
import 'splitter.dart';
void main() {
  runApp(const ExpenseSplitterApp());
}

class ExpenseSplitterApp extends StatelessWidget {
  const ExpenseSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Splitter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

