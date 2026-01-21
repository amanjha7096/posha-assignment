import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/core/enums/view_mode.dart';
import 'package:recipe/features/recipes/domain/entities/recipe.dart';
import 'package:recipe/features/recipes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:recipe/features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart' hide ToggleViewMode;
import 'package:recipe/features/recipes/presentation/pages/favorites_page.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_list_view.dart';
import 'package:recipe/features/recipes/presentation/widgets/shimmer_loading.dart';
import 'package:recipe/l10n/app_localizations.dart';

@GenerateMocks([FavoritesBloc, RecipeListBloc])
import 'favorites_page_test.mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;
  late MockRecipeListBloc mockRecipeListBloc;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
    mockRecipeListBloc = MockRecipeListBloc();

    when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(const FavoritesState()));
    when(mockFavoritesBloc.state).thenReturn(const FavoritesState());
    when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(const RecipeListState()));
    when(mockRecipeListBloc.state).thenReturn(const RecipeListState());
  });

  Widget buildTestWidget({required FavoritesBloc favoritesBloc, required RecipeListBloc recipeListBloc}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesBloc>.value(value: favoritesBloc),
        BlocProvider<RecipeListBloc>.value(value: recipeListBloc),
      ],
      child: MaterialApp(
        home: const FavoritesPage(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('FavoritesPage', () {
    testWidgets('renders app bar with title and view mode toggle', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.text('Favorite Recipes'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('dispatches LoadFavorites and LoadRecipes on init', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      verify(mockFavoritesBloc.add(argThat(isA<LoadFavorites>()))).called(1);
      verify(mockRecipeListBloc.add(argThat(isA<LoadRecipes>()))).called(1);
    });

    testWidgets('shows loading shimmer when loading', (tester) async {
      const loadingFavoritesState = FavoritesState(isLoading: true, viewMode: ViewMode.grid, favoriteIds: []);
      const loadingRecipeState = RecipeListState(isLoading: true);

      when(mockFavoritesBloc.state).thenReturn(loadingFavoritesState);
      when(mockRecipeListBloc.state).thenReturn(loadingRecipeState);

      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(loadingFavoritesState));
      when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(loadingRecipeState));

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));

      await tester.pump();

      expect(find.byType(ShimmerLoading), findsOneWidget);
    });

    testWidgets('shows empty state when no favorites', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: [], isLoading: false));
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('No favorite recipes yet'), findsOneWidget);
      expect(find.text('Add recipes to favorites from the recipe details'), findsOneWidget);
    });

    testWidgets('shows favorite recipes when favorites exist', (tester) async {
      const testRecipe1 = Recipe(id: '1', name: 'Favorite Recipe 1', ingredients: [], measures: []);
      const testRecipe2 = Recipe(id: '2', name: 'Regular Recipe', ingredients: [], measures: []);

      const favoritesState = FavoritesState(favoriteIds: ['1'], isLoading: false, viewMode: ViewMode.grid);

      final recipeListState = RecipeListState(recipes: [testRecipe1, testRecipe2], isLoading: false);

      when(mockFavoritesBloc.state).thenReturn(favoritesState);
      when(mockRecipeListBloc.state).thenReturn(recipeListState);

      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(favoritesState));
      when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(recipeListState));

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));

      await tester.pump();

      expect(find.byType(RecipeList), findsOneWidget);
      expect(find.text('Favorite Recipe 1'), findsOneWidget);

      expect(find.text('Regular Recipe'), findsNothing);
    });

    testWidgets('filters recipes correctly based on favorites', (tester) async {
      const testRecipe1 = Recipe(id: '1', name: 'Recipe 1', ingredients: [], measures: []);
      const testRecipe2 = Recipe(id: '2', name: 'Recipe 2', ingredients: [], measures: []);
      const testRecipe3 = Recipe(id: '3', name: 'Recipe 3', ingredients: [], measures: []);

      const favoritesState = FavoritesState(favoriteIds: ['1', '3'], isLoading: false, viewMode: ViewMode.list);

      final recipeListState = RecipeListState(recipes: [testRecipe1, testRecipe2, testRecipe3], isLoading: false);

      when(mockFavoritesBloc.state).thenReturn(favoritesState);
      when(mockRecipeListBloc.state).thenReturn(recipeListState);

      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(favoritesState));
      when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(recipeListState));

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));

      await tester.pump();

      expect(find.byType(RecipeList), findsOneWidget);
      expect(find.text('Recipe 1'), findsOneWidget);
      expect(find.text('Recipe 2'), findsNothing); // Properly filtered out
      expect(find.text('Recipe 3'), findsOneWidget);
    });

    testWidgets('toggles view mode when ViewModeToggleButton is tapped', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(viewMode: ViewMode.grid));
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      final viewModeButton = find.byIcon(Icons.view_list);
      expect(viewModeButton, findsOneWidget);

      await tester.tap(viewModeButton);
      await tester.pump();

      verify(mockFavoritesBloc.add(argThat(isA<ToggleViewMode>()))).called(1);
    });

    testWidgets('shows List icon when in Grid mode', (tester) async {
      const gridState = FavoritesState(viewMode: ViewMode.grid);

      when(mockFavoritesBloc.state).thenReturn(gridState);
      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(gridState));

      // Mock dependency
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());
      when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(const RecipeListState()));

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pump();

      // Expect "Switch to List" icon
      expect(find.byIcon(Icons.view_list), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsNothing);
    });

    testWidgets('shows Grid icon when in List mode', (tester) async {
      const listState = FavoritesState(viewMode: ViewMode.list);

      when(mockFavoritesBloc.state).thenReturn(listState);
      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(listState));

      // Mock dependency
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState());
      when(mockRecipeListBloc.stream).thenAnswer((_) => Stream.value(const RecipeListState()));

      await tester.pumpWidget(buildTestWidget(favoritesBloc: mockFavoritesBloc, recipeListBloc: mockRecipeListBloc));
      await tester.pump();

      // Expect "Switch to Grid" icon
      expect(find.byIcon(Icons.grid_view), findsOneWidget);
      expect(find.byIcon(Icons.view_list), findsNothing);
    });
  });
}
