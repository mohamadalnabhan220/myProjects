import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String _base = "192.168.0.102";

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> _recipes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final url = Uri.http(_base, "recipe_box/get_recipes.php");
    final response = await http.get(url);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    try {
      if (response.statusCode == 200) {
        final List<dynamic> recipes = json.decode(response.body);
        print("Recipes fetched: $recipes");

        setState(() {
          _recipes = recipes;
        });
      } else {
        print("Failed to fetch recipes, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error decoding JSON: $e");
    }
  }
  Future<void> _addRecipe(String title, String ingredients) async {
    final url = Uri.http(_base, 'recipe_box/add_recipe.php');
    print("Sending POST request with title: $title, ingredients: $ingredients");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'title': title, 'ingredients': ingredients},
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Decoded response: $data");
      if (data['success']) {
        _fetchRecipes(); // Refresh the recipe list after adding
      } else {
        print("Error: ${data['error']}");
      }
    } else {
      print("Failed to add recipe.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Box'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchRecipes,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Add Your Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      maxLength: 50, // Limit title length
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _ingredientsController,
                      decoration: InputDecoration(
                        labelText: 'Ingredients',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      maxLines: 3, // Allow multiple lines for ingredients
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Save Recipe'),
                      onPressed: () {
                        final title = _titleController.text;
                        final ingredients = _ingredientsController.text;
                        if (title.isNotEmpty && ingredients.isNotEmpty) {
                          _addRecipe(title, ingredients);
                        } else {
                          print('Please fill in both fields');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _recipes.isEmpty
                ? Center(child: CircularProgressIndicator()) // Show loading spinner if no data is available
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        recipe['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(recipe['ingredients']),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // You could open a dialog here to add a recipe if you prefer.
          print('Floating action button pressed');
        },
      ),
    );
  }
}
