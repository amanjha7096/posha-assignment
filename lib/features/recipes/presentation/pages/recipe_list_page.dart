import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/utils/localization_extension.dart';
import 'package:recipe/features/recipes/presentation/widgets/view_mode_toggle_button.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';
import '../widgets/filter_button_widget.dart';
import '../widgets/recipe_list_view.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_loading.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RecipeListBloc>().add(LoadRecipes());
    context.read<RecipeListBloc>().add(LoadCategories());
    context.read<RecipeListBloc>().add(LoadAreas());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Text(l10n.recipesTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite), onPressed: () => context.go('/favorites')),
          BlocBuilder<RecipeListBloc, RecipeListState>(
            builder: (context, state) {
              return ViewModeToggleButton(
                viewMode: state.viewMode,
                onPressed: () =>
                    context.read<RecipeListBloc>().add(ToggleViewMode()),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      controller: _searchController,
                      onSearch: (value) =>
                          context.read<RecipeListBloc>().add(SearchRecipes(value)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const FilterButtonWidget(),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<RecipeListBloc, RecipeListState>(
                builder: (context, state) {
                  if (state.isLoading && state.recipes.isEmpty) {
                    return ShimmerLoading(viewMode: state.viewMode);
                  } else if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<RecipeListBloc>().add(LoadRecipes());
                            },
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  } else if (state.displayRecipes.isEmpty) {
                    return Center(child: Text(l10n.noRecipesFound));
                  }

                  return RecipeList(
                      recipes: state.displayRecipes, viewMode: state.viewMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
