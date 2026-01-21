import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/recipes/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    final sampleJson = {
      "idCategory": "1",
      "strCategory": "Chicken",
      "strCategoryThumb": "https://image.jpg",
      "strCategoryDescription": "Chicken dishes are delicious",
    };

    test('fromJson parses category correctly', () {
      final model = CategoryModel.fromJson(sampleJson);

      expect(model.id, "1");
      expect(model.name, "Chicken");
      expect(model.imageUrl, "https://image.jpg");
      expect(model.description, "Chicken dishes are delicious");
    });

    test('toJson converts model to map correctly', () {
      final model = CategoryModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['idCategory'], "1");
      expect(json['strCategory'], "Chicken");
      expect(json['strCategoryThumb'], "https://image.jpg");
      expect(json['strCategoryDescription'], "Chicken dishes are delicious");
    });

    test('toEntity converts model to domain entity', () {
      final model = CategoryModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.imageUrl, model.imageUrl);
      expect(entity.description, model.description);
    });
  });

  group('CategoryResponse', () {
    test('fromJson returns list of CategoryModel', () {
      final responseJson = {
        "categories": [
          {"idCategory": "1", "strCategory": "Chicken"},
          {"idCategory": "2", "strCategory": "Beef"},
        ],
      };

      final response = CategoryResponse.fromJson(responseJson);

      expect(response.categories.length, 2);
      expect(response.categories.first.name, "Chicken");
      expect(response.categories.last.name, "Beef");
    });

    test('fromJson returns empty list when categories is null', () {
      final response = CategoryResponse.fromJson({"categories": null});

      expect(response.categories.isEmpty, true);
    });
  });
}
