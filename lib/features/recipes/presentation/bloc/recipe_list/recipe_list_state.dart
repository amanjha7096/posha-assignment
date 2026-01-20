part of 'recipe_list_bloc.dart';

enum ViewMode { grid, list }

class RecipeListState {
  final List<Recipe> recipes;
  final List<Recipe> filteredRecipes;
  final bool isLoading;
  final String? error;
  final ViewMode viewMode;
  final String? selectedCategory;
  final String? selectedArea;
  final String sortBy;
  final List<Category> categories;
  final List<String> areas;

  const RecipeListState({
    this.recipes = const [],
    this.filteredRecipes = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = ViewMode.grid,
    this.selectedCategory,
    this.selectedArea,
    this.sortBy = 'name',
    this.categories = const [],
    this.areas = const [],
  });

  RecipeListState copyWith({
    List<Recipe>? recipes,
    List<Recipe>? filteredRecipes,
    bool? isLoading,
    String? error,
    ViewMode? viewMode,
    String? selectedCategory,
    String? selectedArea,
    String? sortBy,
    List<Category>? categories,
    List<String>? areas,
  }) {
    return RecipeListState(
      recipes: recipes ?? this.recipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewMode: viewMode ?? this.viewMode,
      selectedCategory: selectedCategory,
      selectedArea: selectedArea,
      sortBy: sortBy ?? this.sortBy,
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
    );
  }

  List<Recipe> get displayRecipes {
    var recipes = List<Recipe>.from(filteredRecipes);

    // Sort recipes
    if (sortBy == 'name') {
      recipes.sort((a, b) => a.name.compareTo(b.name));
    }

    return recipes;
  }

  int get activeFiltersCount {
    int count = 0;
    if (selectedCategory != null) count++;
    if (selectedArea != null) count++;
    return count;
  }
}
