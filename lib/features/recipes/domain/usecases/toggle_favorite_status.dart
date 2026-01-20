import '../repositories/recipe_repository.dart';

class ToggleFavoriteStatus {
  final RecipeRepository repository;

  ToggleFavoriteStatus(this.repository);

  Future<void> call(String recipeId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      await repository.removeFromFavorites(recipeId);
    } else {
      await repository.addToFavorites(recipeId);
    }
  }
}
