import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:recipe/core/enums/view_mode.dart';
import 'package:recipe/features/recipes/domain/usecases/get_recipes.dart';
import 'package:recipe/features/recipes/domain/usecases/get_categories.dart';
import 'package:recipe/features/recipes/domain/usecases/get_areas.dart';
import 'package:recipe/features/recipes/domain/entities/recipe.dart';
import 'package:recipe/features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';

@GenerateMocks([GetRecipes, GetCategories, GetAreas])
import 'recipe_list_bloc_test.mocks.dart';

void main() {
  late RecipeListBloc bloc;
  late MockGetRecipes mockGetRecipes;
  late MockGetCategories mockGetCategories;
  late MockGetAreas mockGetAreas;

  setUp(() {
    mockGetRecipes = MockGetRecipes();
    mockGetCategories = MockGetCategories();
    mockGetAreas = MockGetAreas();
    bloc = RecipeListBloc(mockGetRecipes, mockGetCategories, mockGetAreas);
  });

  tearDown(() {
    bloc.close();
  });

  group('RecipeListBloc', () {
    final testRecipes = [
      Recipe(id: '1', name: 'Test Recipe 1', ingredients: ['Ingredient 1'], measures: ['Measure 1']),
      Recipe(id: '2', name: 'Test Recipe 2', ingredients: ['Ingredient 2'], measures: ['Measure 2']),
    ];

    blocTest<RecipeListBloc, RecipeListState>(
      'emits loading then recipes when LoadRecipes is added',
      build: () {
        when(mockGetRecipes()).thenAnswer((_) async => testRecipes);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRecipes()),
      expect: () => [
        isA<RecipeListState>().having((state) => state.isLoading, 'isLoading', true),
        isA<RecipeListState>()
            .having((state) => state.recipes, 'recipes', testRecipes)
            .having((state) => state.filteredRecipes, 'filteredRecipes', testRecipes)
            .having((state) => state.isLoading, 'isLoading', false),
      ],
    );

    blocTest<RecipeListBloc, RecipeListState>(
      'emits loading then error when LoadRecipes fails',
      build: () {
        when(mockGetRecipes()).thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRecipes()),
      expect: () => [
        isA<RecipeListState>().having((state) => state.isLoading, 'isLoading', true),
        isA<RecipeListState>()
            .having((state) => state.isLoading, 'isLoading', false)
            .having((state) => state.error, 'error', 'Exception: Network error'),
      ],
    );

    blocTest<RecipeListBloc, RecipeListState>(
      'filters recipes correctly when SearchRecipes is added',
      build: () {
        when(mockGetRecipes(query: 'Test')).thenAnswer((_) async => [testRecipes.first]);
        return bloc;
      },
      act: (bloc) => bloc.add(SearchRecipes('Test')),
      expect: () => [
        isA<RecipeListState>().having((state) => state.isLoading, 'isLoading', true),
        isA<RecipeListState>()
            .having((state) => state.filteredRecipes.length, 'filteredRecipes length', 1)
            .having((state) => state.isLoading, 'isLoading', false),
      ],
    );

    blocTest<RecipeListBloc, RecipeListState>(
      'clears filters when ClearFilters is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ClearFilters()),
      expect: () => [
        isA<RecipeListState>()
            .having((state) => state.selectedCategories, 'selectedCategories', [])
            .having((state) => state.selectedAreas, 'selectedAreas', [])
            .having((state) => state.pendingSelectedCategories, 'pendingSelectedCategories', [])
            .having((state) => state.pendingSelectedAreas, 'pendingSelectedAreas', []),
      ],
    );

    blocTest<RecipeListBloc, RecipeListState>(
      'toggles view mode when ToggleViewMode is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ToggleViewMode()),
      expect: () => [isA<RecipeListState>().having((state) => state.viewMode, 'viewMode', ViewMode.list)],
    );
  });
}
