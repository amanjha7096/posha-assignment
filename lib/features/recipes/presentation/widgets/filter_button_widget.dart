import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';
import 'filter_bottom_sheet.dart';

class FilterButtonWidget extends StatelessWidget {
  const FilterButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                context
                    .read<RecipeListBloc>()
                    .add(SetPendingToSelected());
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28)),
                  ),
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<RecipeListBloc>(
                        context),
                    child: const FilterBottomSheet(),
                  ),
                );
              },
              icon: const Icon(Icons.filter_list),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (state.activeFiltersCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle),
                  child: Text(
                    '${state.activeFiltersCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
