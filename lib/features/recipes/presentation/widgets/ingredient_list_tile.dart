import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/colors.dart';

class IngredientListTile extends StatelessWidget {
  final String ingredient;
  final String? measure;

  const IngredientListTile({
    super.key,
    required this.ingredient,
    this.measure,
  });

  @override
  Widget build(BuildContext context) {
    const double imageRadius = 20;
    const double imageDiameter = imageRadius * 2;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black05,
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Ingredient Image
          Container(
            width: imageDiameter,
            height: imageDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gray100,
              border: Border.all(color: AppColors.gray200, width: 1),
            ),
            child: ClipOval(
              child: Image.network(
                'https://www.themealdb.com/images/ingredients/${ingredient.replaceAll(' ', '_')}-small.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.gray500,
                    size: 20,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.gray500,
                    size: 20,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Ingredient Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ingredient Name
                Text(
                  ingredient,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Quantity if available
                if (measure != null && measure!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    measure!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
