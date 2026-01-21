import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/core/enums/view_mode.dart';
import 'package:recipe/features/recipes/domain/entities/recipe.dart';
import 'package:recipe/features/recipes/presentation/bloc/favorites/favorites_bloc.dart' hide ToggleViewMode;
import 'package:recipe/features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';
import 'package:recipe/features/recipes/presentation/pages/recipe_list_page.dart';
import 'package:recipe/features/recipes/presentation/widgets/filter_button_widget.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_list_view.dart';
import 'package:recipe/features/recipes/presentation/widgets/search_bar_widget.dart';
import 'package:recipe/features/recipes/presentation/widgets/shimmer_loading.dart';
import 'package:recipe/features/recipes/presentation/widgets/view_mode_toggle_button.dart';
import 'package:recipe/l10n/app_localizations.dart';

@GenerateMocks([RecipeListBloc, FavoritesBloc])
import 'recipe_list_page_test.mocks.dart';

void main() {
  late MockRecipeListBloc mockRecipeListBloc;
  late MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockRecipeListBloc = MockRecipeListBloc();
    mockFavoritesBloc = MockFavoritesBloc();

    when(mockRecipeListBloc.stream).thenAnswer((_) => const Stream<RecipeListState>.empty());
    when(mockRecipeListBloc.state).thenReturn(const RecipeListState());

    when(mockFavoritesBloc.stream).thenAnswer((_) => const Stream<FavoritesState>.empty());
    when(mockFavoritesBloc.state).thenReturn(const FavoritesState());
  });

  Widget buildTestWidget({required RecipeListBloc recipeListBloc, GoRouter? router}) {
    final goRouter =
        router ??
        GoRouter(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const RecipeListPage()),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const Scaffold(body: Text('Favorites Page')),
            ),
          ],
        );

    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipeListBloc>.value(value: recipeListBloc),
        BlocProvider<FavoritesBloc>.value(value: mockFavoritesBloc),
      ],
      child: MaterialApp.router(
        routerConfig: goRouter,
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

  group('RecipeListPage Widget Tests', () {
    testWidgets('renders app bar with title and actions', (tester) async {
      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.text('Recipes'), findsOneWidget); 
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byType(IconButton), findsAtLeast(2));
    });

    testWidgets('dispatches LoadRecipes, LoadCategories, and LoadAreas on init', (tester) async {
      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      verify(mockRecipeListBloc.add(argThat(isA<LoadRecipes>()))).called(1);
      verify(mockRecipeListBloc.add(argThat(isA<LoadCategories>()))).called(1);
      verify(mockRecipeListBloc.add(argThat(isA<LoadAreas>()))).called(1);
    });

    testWidgets('navigates to favorites page when favorite icon is tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(find.text('Favorites Page'), findsOneWidget);
    });

    testWidgets('shows loading shimmer when loading and no recipes', (tester) async {
      when(
        mockRecipeListBloc.state,
      ).thenReturn(const RecipeListState(isLoading: true, recipes: [], viewMode: ViewMode.grid));

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pump();

      expect(find.byType(ShimmerLoading), findsOneWidget);
    });

    testWidgets('shows error message and retry button when error occurs', (tester) async {
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState(error: 'Network error'));

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows no recipes found message when displayRecipes is empty', (tester) async {
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState(recipes: [], filteredRecipes: []));

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.text('No recipes found'), findsOneWidget);
    });

    testWidgets('shows RecipeList when recipes are available', (tester) async {
      const recipe = Recipe(id: '1', name: 'Test Recipe', ingredients: [], measures: []);

      when(mockRecipeListBloc.state).thenReturn(
        RecipeListState(recipes: [recipe], filteredRecipes: [recipe], isLoading: false, viewMode: ViewMode.grid),
      );

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.byType(RecipeList), findsOneWidget);
    });

    testWidgets('contains SearchBarWidget in the UI', (tester) async {
      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.byType(SearchBarWidget), findsOneWidget);
    });

    testWidgets('contains FilterButtonWidget in the UI', (tester) async {
      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pumpAndSettle();

      expect(find.byType(FilterButtonWidget), findsOneWidget);
    });

    testWidgets('toggles view mode when ViewModeToggleButton is tapped', (tester) async {
      // current mode is grid
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState(viewMode: ViewMode.grid));

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pump();

      await tester.tap(find.byType(ViewModeToggleButton));
      await tester.pump();

      expect(find.byIcon(Icons.view_list), findsOneWidget);
      verify(mockRecipeListBloc.add(argThat(isA<ToggleViewMode>()))).called(1);
    });

    testWidgets('shows correct icon in ViewModeToggleButton based on view mode', (tester) async {
      when(mockRecipeListBloc.state).thenReturn(const RecipeListState(viewMode: ViewMode.list));

      await tester.pumpWidget(buildTestWidget(recipeListBloc: mockRecipeListBloc));
      await tester.pump();

      expect(find.byIcon(Icons.grid_view), findsOneWidget);
    });
  });
}
