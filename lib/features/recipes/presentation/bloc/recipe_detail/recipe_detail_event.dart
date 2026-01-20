part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailEvent {}

class LoadRecipeDetails extends RecipeDetailEvent {
  final String recipeId;

  LoadRecipeDetails(this.recipeId);
}

class ToggleFavorite extends RecipeDetailEvent {
  final String recipeId;

  ToggleFavorite(this.recipeId);
}
