part of 'recipe_list_bloc.dart';

abstract class RecipeListEvent {}

class LoadRecipes extends RecipeListEvent {}

class SearchRecipes extends RecipeListEvent {
  final String query;

  SearchRecipes(this.query);
}

class FilterByCategory extends RecipeListEvent {
  final String? category;

  FilterByCategory(this.category);
}

class FilterByArea extends RecipeListEvent {
  final String? area;

  FilterByArea(this.area);
}

class ToggleViewMode extends RecipeListEvent {}

class SortRecipes extends RecipeListEvent {
  final String sortBy;

  SortRecipes(this.sortBy);
}

class ClearFilters extends RecipeListEvent {}

class LoadCategories extends RecipeListEvent {}

class LoadAreas extends RecipeListEvent {}
