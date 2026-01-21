import 'package:flutter/material.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_list_tile.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/enums/view_mode.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_card.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final ViewMode viewMode;

  const RecipeList({super.key, required this.recipes, required this.viewMode});

  @override
  Widget build(BuildContext context) {
    if (viewMode == ViewMode.grid) {
      return _RecipeGridView(recipes: recipes);
    } else {
      return _RecipeListView(recipes: recipes);
    }
  }
}

class _RecipeGridView extends StatelessWidget {
  final List<Recipe> recipes;

  const _RecipeGridView({super.key, required this.recipes});

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

class _RecipeListView extends StatelessWidget {
  final List<Recipe> recipes;

  const _RecipeListView({super.key, required this.recipes});

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
