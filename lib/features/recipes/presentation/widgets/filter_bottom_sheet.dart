import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/localization_extension.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filterRecipes,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<RecipeListBloc>().add(ClearFilters());
                      },
                      child: Text(l10n.clear, style: TextStyle(color: AppColors.gray600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.category, style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 8.0,
                  children: state.categories.map((category) {
                    return FilterChip(
                      label: Text(category.name),
                      selected: state.pendingSelectedCategories.contains(category.name),
                      onSelected: (selected) {
                        final newCategories = selected
                            ? [...state.pendingSelectedCategories, category.name]
                            : state.pendingSelectedCategories.where((c) => c != category.name).toList();
                        context.read<RecipeListBloc>().add(UpdatePendingCategories(newCategories));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(l10n.area, style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 8.0,
                  children: state.areas.map((area) {
                    return FilterChip(
                      label: Text(area),
                      selected: state.pendingSelectedAreas.contains(area),
                      onSelected: (selected) {
                        final newAreas = selected
                            ? [...state.pendingSelectedAreas, area]
                            : state.pendingSelectedAreas.where((a) => a != area).toList();
                        context.read<RecipeListBloc>().add(UpdatePendingAreas(newAreas));
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<RecipeListBloc>().add(ApplyPendingFilters());
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.applyFilters, style: TextStyle(color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
