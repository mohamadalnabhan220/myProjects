import 'package:flutter/material.dart';
import 'recipe_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Box',
      home: RecipeScreen(),
    );
  }
}
