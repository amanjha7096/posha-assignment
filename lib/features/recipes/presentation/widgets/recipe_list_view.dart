import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_list_tile.dart';

class RecipeListView extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeListView({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeListTile(recipe: recipes[index]);
      },
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }
}
