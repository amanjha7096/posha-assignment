import 'package:flutter/material.dart';
import 'package:recipe/features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/enums/view_mode.dart';
import '../../domain/entities/recipe.dart';

class ShimmerLoading extends StatelessWidget {
  final ViewMode viewMode;

  const ShimmerLoading({super.key, required this.viewMode});

  // Create a dummy recipe for skeleton loading
  Recipe _createDummyRecipe() {
    return Recipe(
      id: 'skeleton',
      name: 'Dummy Recipe Name',
      category: 'Category',
      area: 'Area',
      instructions: 'Instructions',
      imageUrl: null,
      ingredients: ['Ingredient 1', 'Ingredient 2'],
      measures: ['1 cup', '2 tbsp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (viewMode == ViewMode.grid) {
      return _RecipeGridShimmerLoading(recipe: _createDummyRecipe());
    } else {
      return _RecipeListShimmerLoading(recipe: _createDummyRecipe());
    }
  }
}

class _RecipeGridShimmerLoading extends StatelessWidget {
  final Recipe recipe;

  const _RecipeGridShimmerLoading({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.gray300,
        highlightColor: AppColors.gray100,
        duration: const Duration(seconds: 1),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemCount: 6, // Show 6 skeleton items
        itemBuilder: (context, index) {
          return RecipeCard(recipe: recipe);
        },
      ),
    );
  }
}

class _RecipeListShimmerLoading extends StatelessWidget {
  final Recipe recipe;

  const _RecipeListShimmerLoading({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.gray300,
        highlightColor: AppColors.gray100,
        duration: const Duration(seconds: 1),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // Show 6 skeleton items
        itemBuilder: (context, index) {
          return RecipeListTile(recipe: recipe);
        },
      ),
    );
  }
}
