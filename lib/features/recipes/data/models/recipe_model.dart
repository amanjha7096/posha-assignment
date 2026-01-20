import '../../domain/entities/recipe.dart';

class RecipeModel {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? imageUrl;
  final String? youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  const RecipeModel({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    this.imageUrl,
    this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    // TheMealDB API has up to 20 ingredients/measures
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString());
        measures.add(measure?.toString() ?? '');
      }
    }

    return RecipeModel(
      id: json['idMeal'].toString(),
      name: json['strMeal'].toString(),
      category: json['strCategory']?.toString(),
      area: json['strArea']?.toString(),
      instructions: json['strInstructions']?.toString(),
      imageUrl: json['strMealThumb']?.toString(),
      youtubeUrl: json['strYoutube']?.toString(),
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': imageUrl,
      'strYoutube': youtubeUrl,
    };

    // Add ingredients and measures
    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i];
      json['strMeasure${i + 1}'] = measures[i];
    }

    return json;
  }

  Recipe toEntity() => Recipe(
        id: id,
        name: name,
        category: category,
        area: area,
        instructions: instructions,
        imageUrl: imageUrl,
        youtubeUrl: youtubeUrl,
        ingredients: ingredients,
        measures: measures,
      );
}

class RecipeResponse {
  final List<RecipeModel> recipes;

  RecipeResponse({required this.recipes});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    final meals = json['meals'];
    if (meals == null || meals is! List) {
      return RecipeResponse(recipes: []);
    }

    final recipes = meals
        .map((meal) => RecipeModel.fromJson(meal as Map<String, dynamic>))
        .toList();

    return RecipeResponse(recipes: recipes);
  }
}
