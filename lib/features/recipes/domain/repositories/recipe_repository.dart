import '../entities/recipe.dart';
import '../entities/category.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes({String? query});
  Future<Recipe> getRecipeDetails(String id);
  Future<List<Category>> getCategories();
  Future<List<String>> getAreas();
  Future<List<Recipe>> filterByCategory(String category);
  Future<List<Recipe>> filterByArea(String area);
  Future<void> addToFavorites(String recipeId);
  Future<void> removeFromFavorites(String recipeId);
  Future<List<String>> getFavorites();
  Future<bool> isFavorite(String recipeId);
}
