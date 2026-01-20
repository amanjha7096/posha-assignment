import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/recipe_detail/recipe_detail_bloc.dart';
import '../widgets/shimmer_loading.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: [
          BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: state.isFavorite ? AppColors.red : null,
                ),
                onPressed: () {
                  context.read<RecipeDetailBloc>().add(ToggleFavorite(recipeId));
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const ShimmerLoading(viewMode: ViewMode.list);
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecipeDetailBloc>().add(LoadRecipeDetails(recipeId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.recipe == null) {
            return const Center(child: Text('Recipe not found'));
          }

          final recipe = state.recipe!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Image
                if (recipe.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(recipe.imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover),
                  ),

                const SizedBox(height: 16),

                // Recipe Name
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Category and Area
                Row(
                  children: [
                    if (recipe.category != null) ...[Chip(label: Text(recipe.category!)), const SizedBox(width: 8)],
                    if (recipe.area != null) Chip(label: Text(recipe.area!)),
                  ],
                ),

                const SizedBox(height: 24),

                // Ingredients
                Text('Ingredients', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                ..._buildIngredientsList(recipe),

                const SizedBox(height: 24),

                // Instructions
                if (recipe.instructions != null) ...[
                  Text('Instructions', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(recipe.instructions!, style: Theme.of(context).textTheme.bodyLarge),
                ],

                // YouTube Video Button
                if (recipe.hasVideo) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Open YouTube video
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Watch Video'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildIngredientsList(recipe) {
    final ingredients = <Widget>[];

    for (int i = 0; i < recipe.ingredients.length; i++) {
      if (recipe.ingredients[i].isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${recipe.measures[i]} ${recipe.ingredients[i]}', style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      }
    }

    return ingredients;
  }
}
