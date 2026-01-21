import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/favorites/favorites_bloc.dart';
import 'favorite_button.dart';

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
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. The Main Card Container
          Container(
            margin: const EdgeInsets.only(top: imageRadius),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black05,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  recipe.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black87,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 8),

                // Area/Category info and Save Button
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Area/Category Info Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cuisine Label and Value
                            Text(
                              "Cuisine",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.gray400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              recipe.area ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Category Label and Value
                            Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.gray400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              recipe.category ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Save/Bookmark Button
                      FavoriteButton(recipeId: recipe.id, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. The Floating Circular Image
          Positioned(
            top: 0,
            child: Hero(
              tag: 'recipe-image-${recipe.id}',
              child: Container(
                width: imageDiameter,
                height: imageDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black15,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: recipe.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.restaurant,
                          color: AppColors.gray500,
                          size: 30,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
