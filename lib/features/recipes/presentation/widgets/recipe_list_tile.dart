import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/favorites/favorites_bloc.dart';
import 'favorite_button.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeListTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    const double imageRadius = 30;
    const double imageDiameter = imageRadius * 2;

    return GestureDetector(
      onTap: () => context.go('/recipe/${recipe.id}'),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. The Main Card Container
          Container(
            margin: const EdgeInsets.only(left: imageRadius),
            padding: const EdgeInsets.fromLTRB(imageRadius + 12, 16, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  recipe.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black87,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Details row: cuisine/category info and favorite button
                Row(
                  children: [
                    // Cuisine and Category info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cuisine
                          Row(
                            children: [
                              Text(
                                "Cuisine: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  recipe.area ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Category
                          Row(
                            children: [
                              Text(
                                "Category: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  recipe.category ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Favorite Button on the right
                    FavoriteButton(recipeId: recipe.id, size: 20),
                  ],
                ),
              ],
            ),
          ),

          // 2. The Floating Circular Image
          Positioned(
            left: 0,
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
