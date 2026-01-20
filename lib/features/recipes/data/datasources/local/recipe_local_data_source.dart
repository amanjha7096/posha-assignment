import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/utils/hive_helper.dart';
import '../../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<void> cacheRecipes(List<RecipeModel> recipes);
  Future<List<RecipeModel>> getCachedRecipes();
  Future<void> addToFavorites(String recipeId);
  Future<void> removeFromFavorites(String recipeId);
  Future<List<String>> getFavorites();
  Future<bool> isFavorite(String recipeId);
  Future<void> cacheRecipeDetails(RecipeModel recipe);
  Future<RecipeModel?> getCachedRecipeDetails(String id);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final Box<String> favoritesBox;
  final Box<String> cacheBox;

  RecipeLocalDataSourceImpl(this.favoritesBox, this.cacheBox);

  factory RecipeLocalDataSourceImpl.create() {
    return RecipeLocalDataSourceImpl(
      Hive.box<String>(HiveHelper.favoritesBox),
      Hive.box<String>(HiveHelper.cacheBox),
    );
  }

  @override
  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    final recipesList = recipes.map((recipe) => recipe.toJson()).toList();
    await cacheBox.put('recipes', jsonEncode(recipesList));
  }

  @override
  Future<List<RecipeModel>> getCachedRecipes() async {
    final recipesJson = cacheBox.get('recipes');
    if (recipesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(recipesJson);
    return decoded
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addToFavorites(String recipeId) async {
    await favoritesBox.put(recipeId, recipeId);
  }

  @override
  Future<void> removeFromFavorites(String recipeId) async {
    await favoritesBox.delete(recipeId);
  }

  @override
  Future<List<String>> getFavorites() async {
    return favoritesBox.values.toList();
  }

  @override
  Future<bool> isFavorite(String recipeId) async {
    return favoritesBox.containsKey(recipeId);
  }

  @override
  Future<void> cacheRecipeDetails(RecipeModel recipe) async {
    final recipeJson = recipe.toJson();
    await cacheBox.put('recipe_${recipe.id}', jsonEncode(recipeJson));
  }

  @override
  Future<RecipeModel?> getCachedRecipeDetails(String id) async {
    final recipeJson = cacheBox.get('recipe_$id');
    if (recipeJson == null) return null;

    final Map<String, dynamic> decoded = jsonDecode(recipeJson);
    return RecipeModel.fromJson(decoded);
  }
}
