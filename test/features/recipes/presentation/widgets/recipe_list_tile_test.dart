import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/features/recipes/domain/entities/recipe.dart';
import 'package:recipe/features/recipes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:recipe/features/recipes/presentation/widgets/recipe_list_tile.dart';

@GenerateMocks([FavoritesBloc, GoRouter])
import 'recipe_list_tile_test.mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
    mockGoRouter = MockGoRouter();

    // Stub the stream property for BlocBuilder
    when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(const FavoritesState()));
  });

  const testRecipe = Recipe(
    id: '1',
    name: 'Test Recipe',
    category: 'Test Category',
    area: 'Test Area',
    instructions: 'Test instructions',
    imageUrl: 'https://example.com/image.jpg',
    youtubeUrl: 'https://youtube.com/watch?v=test',
    ingredients: ['Ingredient 1', 'Ingredient 2'],
    measures: ['1 cup', '2 tbsp'],
  );

  const testRecipeWithoutImage = Recipe(
    id: '2',
    name: 'Recipe Without Image',
    category: 'Dessert',
    area: 'Italian',
    ingredients: [],
    measures: [],
  );

  Widget buildTestWidget({required Recipe recipe, required FavoritesBloc favoritesBloc}) {
    return MultiBlocProvider(
      providers: [BlocProvider<FavoritesBloc>.value(value: favoritesBloc)],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 800, height: 200, child: RecipeListTile(recipe: recipe)),
        ),
      ),
    );
  }

  group('RecipeListTile', () {
    testWidgets('renders recipe information correctly', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      expect(find.text('Test Recipe'), findsOneWidget);

      expect(find.text('Cuisine: '), findsOneWidget);
      expect(find.text('Test Area'), findsOneWidget);

      expect(find.text('Category: '), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
    });

    testWidgets('displays default values when area and category are null', (tester) async {
      const recipeWithNulls = Recipe(id: '3', name: 'Recipe with Nulls', ingredients: [], measures: []);

      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: recipeWithNulls, favoritesBloc: mockFavoritesBloc));

      expect(find.text('Unknown'), findsNWidgets(2)); // one for area one for category
    });

    testWidgets('displays network image when imageUrl is provided', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      // CachedNetworkImage should be present
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays default icon when imageUrl is null or empty', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipeWithoutImage, favoritesBloc: mockFavoritesBloc));

      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });

    testWidgets('has correct styling and layout', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      // Check container styling
      expect(containerWidget.decoration, isA<BoxDecoration>());
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, AppColors.white);
      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('has Hero widget with correct tag', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      final hero = find.byType(Hero);
      expect(hero, findsOneWidget);

      final heroWidget = tester.widget<Hero>(hero);
      expect(heroWidget.tag, 'recipe-image-1');
    });

    testWidgets('has GestureDetector for navigation', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsNWidgets(2));
    });

    testWidgets('includes FavoriteButton with correct recipeId', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(buildTestWidget(recipe: testRecipe, favoritesBloc: mockFavoritesBloc));

      // the FavoriteButton should be rendere,We can check for it by looking for the BlocBuilder wraping it
      final blocBuilder = find.byType(BlocBuilder<FavoritesBloc, FavoritesState>);
      expect(blocBuilder, findsOneWidget);
    });

    testWidgets('navigates to recipe detail page when tapped', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState());
      when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(const FavoritesState()));

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [BlocProvider<FavoritesBloc>.value(value: mockFavoritesBloc)],
                child: Scaffold(
                  body: SizedBox(width: 800, height: 200, child: RecipeListTile(recipe: testRecipe)),
                ),
              );
            },
          ),
          GoRoute(
            path: '/recipe/:id',
            builder: (context, state) => const Scaffold(body: Text('Recipe Detail Page')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Tap the tile
      await tester.tap(find.byType(RecipeListTile));
      await tester.pumpAndSettle();

      // Assert navigation
      expect(find.text('Recipe Detail Page'), findsOneWidget);
    });
  });
}
