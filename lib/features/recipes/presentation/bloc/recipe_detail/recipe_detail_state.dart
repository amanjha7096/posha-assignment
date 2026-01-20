part of 'recipe_detail_bloc.dart';

class RecipeDetailState {
  final bool isLoading;
  final Recipe? recipe;
  final String? error;
  final bool isFavorite;

  const RecipeDetailState({
    this.isLoading = false,
    this.recipe,
    this.error,
    this.isFavorite = false,
  });

  RecipeDetailState copyWith({
    bool? isLoading,
    Recipe? recipe,
    String? error,
    bool? isFavorite,
  }) {
    return RecipeDetailState(
      isLoading: isLoading ?? this.isLoading,
      recipe: recipe ?? this.recipe,
      error: error ?? this.error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
