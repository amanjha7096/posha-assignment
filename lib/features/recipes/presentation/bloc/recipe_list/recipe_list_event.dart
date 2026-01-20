part of 'recipe_list_bloc.dart';

abstract class RecipeListEvent {}

class LoadRecipes extends RecipeListEvent {}

class SearchRecipes extends RecipeListEvent {
  final String query;

  SearchRecipes(this.query);
}

class SetPendingToSelected extends RecipeListEvent {}

class UpdatePendingCategories extends RecipeListEvent {
  final List<String> categories;

  UpdatePendingCategories(this.categories);
}

class UpdatePendingAreas extends RecipeListEvent {
  final List<String> areas;

  UpdatePendingAreas(this.areas);
}

class ApplyPendingFilters extends RecipeListEvent {}

class ToggleViewMode extends RecipeListEvent {}

class SortRecipes extends RecipeListEvent {
  final String sortBy;

  SortRecipes(this.sortBy);
}

class ClearFilters extends RecipeListEvent {}

class LoadCategories extends RecipeListEvent {}

class LoadAreas extends RecipeListEvent {}
