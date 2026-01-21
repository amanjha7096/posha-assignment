import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/recipes/data/models/recipe_model.dart';

void main() {
  group('RecipeModel', () {
    final sampleJson = {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken Casserole",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "Cook the chicken...",
      "strMealThumb": "https://image.jpg",
      "strYoutube": "https://youtube.com/watch?v=abc",
      "strIngredient1": "Chicken",
      "strMeasure1": "500g",
      "strIngredient2": "Soy Sauce",
      "strMeasure2": "2 tbsp",
    };

    test('fromJson parses recipe correctly', () {
      final model = RecipeModel.fromJson(sampleJson);

      expect(model.id, "52772");
      expect(model.name, "Teriyaki Chicken Casserole");
      expect(model.category, "Chicken");
      expect(model.area, "Japanese");
      expect(model.ingredients.length, 2);
      expect(model.ingredients.first, "Chicken");
      expect(model.measures.first, "500g");
    });

    test('toJson converts model to map correctly', () {
      final model = RecipeModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['idMeal'], "52772");
      expect(json['strMeal'], "Teriyaki Chicken Casserole");
      expect(json['strIngredient1'], "Chicken");
      expect(json['strMeasure2'], "2 tbsp");
    });

    test('toEntity converts model to domain entity', () {
      final model = RecipeModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.ingredients, model.ingredients);
    });
  });

  group('RecipeResponse', () {
    test('fromJson returns list of RecipeModel', () {
      final responseJson = {
        "meals": [
          {"idMeal": "1", "strMeal": "Burger", "strIngredient1": "Beef", "strMeasure1": "200g"},
        ],
      };

      final response = RecipeResponse.fromJson(responseJson);

      expect(response.recipes.length, 1);
      expect(response.recipes.first.name, "Burger");
    });

    test('fromJson returns empty list when meals is null', () {
      final response = RecipeResponse.fromJson({"meals": null});

      expect(response.recipes.isEmpty, true);
    });
  });
}
