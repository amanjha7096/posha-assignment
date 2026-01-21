import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/favorites/favorites_bloc.dart';

class FavoriteButton extends StatelessWidget {
  final String recipeId;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  const FavoriteButton({super.key, required this.recipeId, this.onTap, this.size = 24.0, this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(recipeId);

        return GestureDetector(
          onTap: () {
            onTap?.call();
            context.read<FavoritesBloc>().add(ToggleFavorite(recipeId));
          },
          child: AnimatedScale(
            scale: isFavorite ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.black05, blurRadius: 4, spreadRadius: 1)],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: size,
                color: color ?? (isFavorite ? AppColors.red : AppColors.gray500),
              ),
            ),
          ),
        );
      },
    );
  }
}
