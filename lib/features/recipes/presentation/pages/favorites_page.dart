import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';
import '../widgets/shimmer_loading.dart';
import '../../domain/usecases/get_recipe_details.dart';

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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              // Toggle view mode could be implemented here
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ShimmerLoading(viewMode: ViewMode.list);
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
                      context.read<FavoritesBloc>().add(LoadFavorites());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.favoriteIds.isEmpty) {
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.favoriteIds.length,
            itemBuilder: (context, index) {
              final recipeId = state.favoriteIds[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FavoriteRecipeCard(
                  recipeId: recipeId,
                  onTap: () {
                    context.go('/recipe/$recipeId');
                  },
                  onRemoveFavorite: () {
                    context.read<FavoritesBloc>().add(ToggleFavorite(recipeId));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteRecipeCard extends StatefulWidget {
  final String recipeId;
  final VoidCallback onTap;
  final VoidCallback onRemoveFavorite;

  const FavoriteRecipeCard({super.key, required this.recipeId, required this.onTap, required this.onRemoveFavorite});

  @override
  State<FavoriteRecipeCard> createState() => _FavoriteRecipeCardState();
}

class _FavoriteRecipeCardState extends State<FavoriteRecipeCard> {
  Map<String, dynamic>? recipeData;

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    try {
      final recipe = await di.sl<GetRecipeDetails>().call(widget.recipeId);
      if (mounted) {
        setState(() {
          recipeData = {
            'id': recipe.id,
            'name': recipe.name,
            'imageUrl': recipe.imageUrl,
            'category': recipe.category,
            'area': recipe.area,
          };
        });
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData == null) {
      return const SizedBox(height: 100, child: ShimmerLoading(viewMode: ViewMode.list));
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Recipe Image
              if (recipeData!['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(recipeData!['imageUrl'], width: 80, height: 80, fit: BoxFit.cover),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.restaurant, size: 40, color: AppColors.gray500),
                ),

              const SizedBox(width: 16),

              // Recipe Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipeData!['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (recipeData!['category'] != null || recipeData!['area'] != null)
                      Row(
                        children: [
                          if (recipeData!['category'] != null) ...[
                            Text(
                              recipeData!['category'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
                            ),
                            if (recipeData!['area'] != null) const Text(' • '),
                          ],
                          if (recipeData!['area'] != null)
                            Text(
                              recipeData!['area'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
                            ),
                        ],
                      ),
                  ],
                ),
              ),

              // Remove Favorite Button
              IconButton(
                icon: const Icon(Icons.favorite, color: AppColors.red),
                onPressed: widget.onRemoveFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
