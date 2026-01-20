import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/favorites/favorites_bloc.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Define the size of the overflowing image
    const double imageRadius = 40;
    const double imageDiameter = imageRadius * 2;

    return GestureDetector(
      onTap: () => context.go('/recipe/${recipe.id}'),
      child: Stack(
        clipBehavior: .none,
        alignment: .center,
        children: [
          // 1. The Main Card Container
          Container(
            margin: const EdgeInsets.only(top: imageRadius),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: AppColors.black05, blurRadius: 15, offset: const Offset(0, 4), spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              children: [
                // Title
                Text(
                  recipe.name,
                  textAlign: .center,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: .w700, color: AppColors.black87, height: 1),
                ),

                const SizedBox(height: 8),

                // Area/Category info and Save Button
                Expanded(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .end,
                    children: [
                      // Area/Category Info Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            // Cuisine Label and Value
                            Text(
                              "Cuisine",
                              style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: .w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              recipe.area ?? 'Unknown',
                              style: const TextStyle(fontSize: 12, fontWeight: .w600, color: AppColors.black87),
                            ),
                            const SizedBox(height: 4),
                            // Category Label and Value
                            Text(
                              "Category",
                              style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: .w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              recipe.category ?? 'Unknown',
                              style: const TextStyle(fontSize: 12, fontWeight: .w600, color: AppColors.black87),
                            ),
                          ],
                        ),
                      ),

                      // Save/Bookmark Button
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          final isFavorite = state.favoriteIds.contains(recipe.id);
                          return GestureDetector(
                            onTap: () => context.read<FavoritesBloc>().add(ToggleFavorite(recipe.id)),
                            child: Container(
                              padding: const .all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: .circle,
                                boxShadow: [BoxShadow(color: AppColors.black05, blurRadius: 4, spreadRadius: 1)],
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: isFavorite ? AppColors.red : AppColors.gray500,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. The Floating Circular Image
          Positioned(
            top: 0,
            child: Container(
              width: imageDiameter,
              height: imageDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [BoxShadow(color: AppColors.black15, blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: ClipOval(
                child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                    ? Image.network(recipe.imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.restaurant, color: AppColors.gray500, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
