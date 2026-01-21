import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/utils/localization_extension.dart';
import 'package:recipe/features/recipes/presentation/widgets/view_mode_toggle_button.dart';
import '../../../../core/constants/colors.dart';
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
        context.read<RecipeListBloc>().add(LoadRecipes());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Text(l10n.favoriteRecipesTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              return ViewModeToggleButton(
                viewMode: state.viewMode,
                onPressed: () => context.read<FavoritesBloc>().add(ToggleViewMode()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                } else if (favoritesState.favoriteIds.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: AppColors.gray500),
                        SizedBox(height: 16),
                        Text(l10n.noFavoriteRecipesYet, style: TextStyle(fontSize: 18, color: AppColors.gray500)),
                        SizedBox(height: 8),
                        Text(
                          l10n.addRecipesToFavoritesHint,
                          style: TextStyle(fontSize: 14, color: AppColors.gray500),
                        ),
                      ],
                    ),
                  );
                }

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
