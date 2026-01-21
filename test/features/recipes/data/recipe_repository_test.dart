import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe/features/recipes/data/datasources/remote/recipe_remote_data_source.dart';
import 'package:recipe/features/recipes/data/datasources/local/recipe_local_data_source.dart';
import 'package:recipe/features/recipes/data/models/recipe_model.dart';
import 'package:recipe/features/recipes/data/models/category_model.dart';

@GenerateMocks([RecipeRemoteDataSource, RecipeLocalDataSource])
import 'recipe_repository_test.mocks.dart';

void main() {
  late RecipeRepositoryImpl repository;
  late MockRecipeRemoteDataSource mockRemoteDataSource;
  late MockRecipeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRecipeRemoteDataSource();
    mockLocalDataSource = MockRecipeLocalDataSource();
    repository = RecipeRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('RecipeRepositoryImpl', () {
    final testRecipeModels = [
      RecipeModel(id: '1', name: 'Test Recipe', ingredients: ['Ingredient 1'], measures: ['Measure 1']),
    ];

    final testRecipeModel = RecipeModel(
      id: '1',
      name: 'Test Recipe',
      ingredients: ['Ingredient 1'],
      measures: ['Measure 1'],
    );

    test('getRecipes returns recipes from remote and caches them', () async {
      when(mockRemoteDataSource.getRecipes()).thenAnswer((_) async => testRecipeModels);
      when(mockLocalDataSource.cacheRecipes(any)).thenAnswer((_) async {});

      final result = await repository.getRecipes();

      expect(result.length, 1);
      expect(result.first.name, 'Test Recipe');
      verify(mockRemoteDataSource.getRecipes());
      verify(mockLocalDataSource.cacheRecipes(testRecipeModels));
    });

    test('getRecipes returns cached recipes when remote fails', () async {
      when(mockRemoteDataSource.getRecipes()).thenThrow(Exception('Network error'));
      when(mockLocalDataSource.getCachedRecipes()).thenAnswer((_) async => testRecipeModels);

      final result = await repository.getRecipes();

      expect(result.length, 1);
      verify(mockLocalDataSource.getCachedRecipes());
    });

    test('getRecipeDetails returns recipe from cache if available', () async {
      when(mockLocalDataSource.getCachedRecipeDetails('1')).thenAnswer((_) async => testRecipeModel);

      final result = await repository.getRecipeDetails('1');

      expect(result.name, 'Test Recipe');
      verify(mockLocalDataSource.getCachedRecipeDetails('1'));
      verifyNever(mockRemoteDataSource.getRecipeDetails(any));
    });

    test('getRecipeDetails fetches from remote when not in cache', () async {
      when(mockLocalDataSource.getCachedRecipeDetails('1')).thenAnswer((_) async => null);
      when(mockRemoteDataSource.getRecipeDetails('1')).thenAnswer((_) async => testRecipeModel);
      when(mockLocalDataSource.cacheRecipeDetails(any)).thenAnswer((_) async {});

      final result = await repository.getRecipeDetails('1');

      expect(result.name, 'Test Recipe');
      verify(mockRemoteDataSource.getRecipeDetails('1'));
      verify(mockLocalDataSource.cacheRecipeDetails(testRecipeModel));
    });

    test('getCategories returns categories from remote', () async {
      final categories = [CategoryModel(id: '1', name: 'Test Category')];
      when(mockRemoteDataSource.getCategories()).thenAnswer((_) async => categories);

      final result = await repository.getCategories();

      expect(result.length, 1);
      expect(result.first.name, 'Test Category');
    });

    test('addToFavorites calls local data source', () async {
      when(mockLocalDataSource.addToFavorites('1')).thenAnswer((_) async {});

      await repository.addToFavorites('1');

      verify(mockLocalDataSource.addToFavorites('1'));
    });

    test('isFavorite returns favorite status', () async {
      when(mockLocalDataSource.isFavorite('1')).thenAnswer((_) async => true);

      final result = await repository.isFavorite('1');

      expect(result, true);
    });
  });
}
