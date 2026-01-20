import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/recipe_model.dart';
import '../../models/category_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes({String? query});
  Future<RecipeModel> getRecipeDetails(String id);
  Future<List<CategoryModel>> getCategories();
  Future<List<String>> getAreas();
  Future<List<RecipeModel>> filterByCategory(String category);
  Future<List<RecipeModel>> filterByArea(String area);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final ApiClient apiClient;

  RecipeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RecipeModel>> getRecipes({String? query}) async {
    final params = {'s': query ?? ''};
    final response = await apiClient.get(ApiEndpoints.searchMeals, params: params);
    final recipeResponse = RecipeResponse.fromJson(response);
    return recipeResponse.recipes;
  }

  @override
  Future<RecipeModel> getRecipeDetails(String id) async {
    final response = await apiClient.get(ApiEndpoints.getMealDetails, params: {'i': id});
    final recipeResponse = RecipeResponse.fromJson(response);
    if (recipeResponse.recipes.isNotEmpty) {
      return recipeResponse.recipes.first;
    } else {
      throw Exception('Recipe not found');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(ApiEndpoints.getCategories);
    final categoryResponse = CategoryResponse.fromJson(response);
    return categoryResponse.categories;
  }

  @override
  Future<List<String>> getAreas() async {
    final response = await apiClient.get(ApiEndpoints.getAreas, params: {'a': 'list'});
    final meals = response['meals'] as List?;
    if (meals == null) return [];

    return meals
        .map((area) => area['strArea'] as String)
        .toList();
  }

  @override
  Future<List<RecipeModel>> filterByCategory(String category) async {
    final response = await apiClient.get(ApiEndpoints.filterByCategory, params: {'c': category});
    final recipeResponse = RecipeResponse.fromJson(response);
    return recipeResponse.recipes;
  }

  @override
  Future<List<RecipeModel>> filterByArea(String area) async {
    final response = await apiClient.get(ApiEndpoints.filterByArea, params: {'a': area});
    final recipeResponse = RecipeResponse.fromJson(response);
    return recipeResponse.recipes;
  }
}
