import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/debouncer.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/recipe_grid_view.dart';
import '../widgets/recipe_list_view.dart';
import '../widgets/shimmer_loading.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

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
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: const Text("Recipes", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(icon: const Icon(Icons.favorite), onPressed: () => context.go('/favorites')),
          BlocBuilder<RecipeListBloc, RecipeListState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<RecipeListBloc>().add(ToggleViewMode());
                },
                icon: Icon(state.viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search recipe',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      onChanged: (value) {
                        _debouncer.run(() {
                          context.read<RecipeListBloc>().add(SearchRecipes(value));
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<RecipeListBloc, RecipeListState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<RecipeListBloc>().add(SetPendingToSelected());
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                                ),
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<RecipeListBloc>(context),
                                  child: const FilterBottomSheet(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.filter_list),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          if (state.activeFiltersCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<RecipeListBloc, RecipeListState>(
                builder: (context, state) {
                  if (state.isLoading && state.recipes.isEmpty) {
                    return ShimmerLoading(viewMode: state.viewMode);
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
                              context.read<RecipeListBloc>().add(LoadRecipes());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.displayRecipes.isEmpty) {
                    return const Center(child: Text('No recipes found'));
                  }

                  if (state.viewMode == ViewMode.grid) {
                    return RecipeGridView(recipes: state.displayRecipes);
                  } else {
                    return RecipeListView(recipes: state.displayRecipes);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
