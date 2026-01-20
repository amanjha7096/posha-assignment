import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipeDetails {
  final RecipeRepository repository;

  GetRecipeDetails(this.repository);

  Future<Recipe> call(String id) async {
    return await repository.getRecipeDetails(id);
  }
}
