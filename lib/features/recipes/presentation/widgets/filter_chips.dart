import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        if (state.categories.isEmpty && state.areas.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.activeFiltersCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.activeFiltersCount}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (state.activeFiltersCount > 0)
                  TextButton(
                    onPressed: () {
                      context.read<RecipeListBloc>().add(ClearFilters());
                    },
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Category filter dropdown
                if (state.categories.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String?>(
                      value: state.selectedCategory,
                      hint: const Text('Category'),
                      underline: const SizedBox.shrink(),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ...state.categories.map((category) {
                          return DropdownMenuItem<String?>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        context.read<RecipeListBloc>().add(FilterByCategory(value));
                      },
                    ),
                  ),

                // Area filter dropdown
                if (state.areas.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String?>(
                      value: state.selectedArea,
                      hint: const Text('Area'),
                      underline: const SizedBox.shrink(),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Areas'),
                        ),
                        ...state.areas.map((area) {
                          return DropdownMenuItem<String?>(
                            value: area,
                            child: Text(area),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        context.read<RecipeListBloc>().add(FilterByArea(value));
                      },
                    ),
                  ),

                // Active filter chips
                if (state.selectedCategory != null)
                  Chip(
                    label: Text('Category: ${state.selectedCategory}'),
                    onDeleted: () {
                      context.read<RecipeListBloc>().add( FilterByCategory(null));
                    },
                  ),

                if (state.selectedArea != null)
                  Chip(
                    label: Text('Area: ${state.selectedArea}'),
                    onDeleted: () {
                      context.read<RecipeListBloc>().add( FilterByArea(null));
                    },
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
