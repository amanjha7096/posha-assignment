import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/enums/view_mode.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart' hide ToggleViewMode;
import '../widgets/recipe_list_view.dart';
import '../widgets/shimmer_loading.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesBloc>().add(LoadFavorites());
        // Ensure recipes are loaded
        context.read<RecipeListBloc>().add(LoadRecipes());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: const Text("Favorite Recipes", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(ToggleViewMode());
                },
                icon: Icon(state.viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: BlocBuilder<RecipeListBloc, RecipeListState>(
          builder: (context, recipeListState) {
            return BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, favoritesState) {
                if (favoritesState.isLoading || recipeListState.isLoading) {
                  return ShimmerLoading(viewMode: favoritesState.viewMode);
                } else if (favoritesState.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(favoritesState.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<FavoritesBloc>().add(LoadFavorites());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (favoritesState.favoriteIds.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: AppColors.gray500),
                        SizedBox(height: 16),
                        Text('No favorite recipes yet', style: TextStyle(fontSize: 18, color: AppColors.gray500)),
                        SizedBox(height: 8),
                        Text(
                          'Add recipes to favorites from the recipe details',
                          style: TextStyle(fontSize: 14, color: AppColors.gray500),
                        ),
                      ],
                    ),
                  );
                }

                // Filter recipes that are favorites
                final favoriteRecipes = recipeListState.recipes
                    .where((recipe) => favoritesState.favoriteIds.contains(recipe.id))
                    .toList();

                return RecipeList(recipes: favoriteRecipes, viewMode: favoritesState.viewMode);
              },
            );
          },
        ),
      ),
    );
  }
}
