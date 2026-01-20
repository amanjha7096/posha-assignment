import '../../domain/entities/recipe.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/remote/recipe_remote_data_source.dart';
import '../datasources/local/recipe_local_data_source.dart';
import '../models/recipe_model.dart';
import '../models/category_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<Recipe>> getRecipes({String? query}) async {
    try {
      final recipeModels = await remoteDataSource.getRecipes(query: query);
      final recipes = recipeModels.map((model) => model.toEntity()).toList();

      // Cache recipes locally for offline access
      await localDataSource.cacheRecipes(recipeModels);

      return recipes;
    } catch (e) {
      // Try to get from cache if network fails
      final cachedRecipes = await localDataSource.getCachedRecipes();
      return cachedRecipes.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Recipe> getRecipeDetails(String id) async {
    try {
      // First check cache
      final cachedRecipe = await localDataSource.getCachedRecipeDetails(id);
      if (cachedRecipe != null) {
        return cachedRecipe.toEntity();
      }

      // Fetch from remote
      final recipeModel = await remoteDataSource.getRecipeDetails(id);

      // Cache for future use
      await localDataSource.cacheRecipeDetails(recipeModel);

      return recipeModel.toEntity();
    } catch (e) {
      // Try cache again
      final cachedRecipe = await localDataSource.getCachedRecipeDetails(id);
      if (cachedRecipe != null) {
        return cachedRecipe.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final categoryModels = await remoteDataSource.getCategories();
    return categoryModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getAreas() async {
    return await remoteDataSource.getAreas();
  }

  @override
  Future<List<Recipe>> filterByCategory(String category) async {
    final recipeModels = await remoteDataSource.filterByCategory(category);
    return recipeModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Recipe>> filterByArea(String area) async {
    final recipeModels = await remoteDataSource.filterByArea(area);
    return recipeModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addToFavorites(String recipeId) async {
    await localDataSource.addToFavorites(recipeId);
  }

  @override
  Future<void> removeFromFavorites(String recipeId) async {
    await localDataSource.removeFromFavorites(recipeId);
  }

  @override
  Future<List<String>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<bool> isFavorite(String recipeId) async {
    return await localDataSource.isFavorite(recipeId);
  }
}
