import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/core/network/api_client.dart';
import 'package:recipe/features/recipes/data/datasources/remote/recipe_remote_data_source.dart';
import 'package:recipe/features/recipes/data/models/recipe_model.dart';
import 'package:recipe/features/recipes/data/models/category_model.dart';

@GenerateMocks([ApiClient])
import 'remote_data_source_test.mocks.dart';

void main() {
  late RecipeRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = RecipeRemoteDataSourceImpl(mockApiClient);
  });

  group('RecipeRemoteDataSourceImpl', () {
    test('getRecipes calls API with correct parameters', () async {
      const query = 'chicken';
      final responseData = {'meals': [{'idMeal': '1', 'strMeal': 'Chicken Curry'}]};
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      final result = await dataSource.getRecipes(query: query);

      expect(result.length, 1);
      expect(result.first.name, 'Chicken Curry');
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/search.php',
          params: {'s': query}));
    });

    test('getRecipeDetails calls API with recipe ID', () async {
      const recipeId = '52772';
      final responseData = {'meals': [{'idMeal': recipeId, 'strMeal': 'Test Recipe'}]};
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      final result = await dataSource.getRecipeDetails(recipeId);

      expect(result.id, recipeId);
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/lookup.php',
          params: {'i': recipeId}));
    });

    test('getRecipeDetails throws exception when recipe not found', () async {
      final responseData = {'meals': null};
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      expect(() => dataSource.getRecipeDetails('999'), throwsException);
    });

    test('getCategories calls API for categories', () async {
      final responseData = {
        'categories': [
          {'idCategory': '1', 'strCategory': 'Chicken', 'strCategoryDescription': 'Chicken dishes'}
        ]
      };
      when(mockApiClient.get(any)).thenAnswer((_) async => responseData);

      final result = await dataSource.getCategories();

      expect(result.length, 1);
      expect(result.first.name, 'Chicken');
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/categories.php'));
    });

    test('getAreas calls API for areas', () async {
      final responseData = {
        'meals': [
          {'strArea': 'Italian'},
          {'strArea': 'Chinese'}
        ]
      };
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      final result = await dataSource.getAreas();

      expect(result, ['Italian', 'Chinese']);
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/list.php',
          params: {'a': 'list'}));
    });

    test('filterByCategory calls API with category parameter', () async {
      const category = 'Seafood';
      final responseData = {'meals': [{'idMeal': '1', 'strMeal': 'Fish Dish'}]};
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      final result = await dataSource.filterByCategory(category);

      expect(result.length, 1);
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/filter.php',
          params: {'c': category}));
    });

    test('filterByArea calls API with area parameter', () async {
      const area = 'Italian';
      final responseData = {'meals': [{'idMeal': '1', 'strMeal': 'Pasta'}]};
      when(mockApiClient.get(any, params: anyNamed('params')))
          .thenAnswer((_) async => responseData);

      final result = await dataSource.filterByArea(area);

      expect(result.length, 1);
      verify(mockApiClient.get('https://www.themealdb.com/api/json/v1/1/filter.php',
          params: {'a': area}));
    });
  });
}
