import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_card.dart';

class RecipeGridView extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeGridView({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }
}
