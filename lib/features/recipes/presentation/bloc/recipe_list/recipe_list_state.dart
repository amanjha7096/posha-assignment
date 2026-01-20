part of 'recipe_list_bloc.dart';

enum ViewMode { grid, list }

class RecipeListState {
  final List<Recipe> recipes;
  final List<Recipe> filteredRecipes;
  final bool isLoading;
  final String? error;
  final ViewMode viewMode;
  final List<String> selectedCategories;
  final List<String> selectedAreas;
  final List<String> pendingSelectedCategories;
  final List<String> pendingSelectedAreas;
  final String sortBy;
  final List<Category> categories;
  final List<String> areas;

  const RecipeListState({
    this.recipes = const [],
    this.filteredRecipes = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = ViewMode.grid,
    this.selectedCategories = const [],
    this.selectedAreas = const [],
    this.pendingSelectedCategories = const [],
    this.pendingSelectedAreas = const [],
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
    List<String>? selectedCategories,
    List<String>? selectedAreas,
    List<String>? pendingSelectedCategories,
    List<String>? pendingSelectedAreas,
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
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      pendingSelectedCategories: pendingSelectedCategories ?? this.pendingSelectedCategories,
      pendingSelectedAreas: pendingSelectedAreas ?? this.pendingSelectedAreas,
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

  int get activeFiltersCount => (selectedCategories.isNotEmpty ? 1 : 0) + (selectedAreas.isNotEmpty ? 1 : 0);
}
