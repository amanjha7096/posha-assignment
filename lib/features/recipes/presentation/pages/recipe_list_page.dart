import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/recipe_list/recipe_list_bloc.dart';
import '../widgets/recipe_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_chips.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final TextEditingController _searchController = TextEditingController();

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
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.go('/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              context.read<RecipeListBloc>().add(ToggleViewMode());
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<RecipeListBloc>().add(SortRecipes(value));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Text('Sort by Name'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<RecipeListBloc>().add(SearchRecipes(query));
                  },
                ),
                const SizedBox(height: 16),
                FilterChipsWidget(),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<RecipeListBloc, RecipeListState>(
              builder: (context, state) {
                if (state.isLoading && state.recipes.isEmpty) {
                  return const ShimmerLoading();
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
                  return const Center(
                    child: Text('No recipes found'),
                  );
                }

                return state.viewMode == ViewMode.grid
                    ? _buildGridView(state.displayRecipes)
                    : _buildListView(state.displayRecipes);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          onTap: () {
            context.go('/recipe/${recipe.id}');
          },
        );
      },
    );
  }

  Widget _buildListView(List<Recipe> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RecipeCard(
            recipe: recipe,
            isListView: true,
            onTap: () {
              context.go('/recipe/${recipe.id}');
            },
          ),
        );
      },
    );
  }
}
