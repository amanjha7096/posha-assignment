import '../repositories/recipe_repository.dart';

class CheckFavorite {
  final RecipeRepository repository;

  CheckFavorite(this.repository);

  Future<bool> call(String recipeId) async {
    return await repository.isFavorite(recipeId);
  }
}
