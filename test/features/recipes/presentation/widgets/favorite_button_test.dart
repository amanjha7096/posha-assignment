import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/features/recipes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:recipe/features/recipes/presentation/widgets/favorite_button.dart';

@GenerateMocks([FavoritesBloc])
import 'favorite_button_test.mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
    when(mockFavoritesBloc.stream).thenAnswer((_) => Stream.value(const FavoritesState()));
  });

  Widget buildTestWidget({
    required String recipeId,
    required FavoritesBloc favoritesBloc,
    VoidCallback? onTap,
    double? size,
    Color? color,
  }) {
    return BlocProvider<FavoritesBloc>.value(
      value: favoritesBloc,
      child: MaterialApp(
        home: Scaffold(
          body: FavoriteButton(recipeId: recipeId, onTap: onTap, size: size ?? 24.0, color: color),
        ),
      ),
    );
  }

  group('FavoriteButton', () {
    testWidgets('renders favorite_border icon when recipe is not favorited', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final icon = find.byIcon(Icons.favorite_border);
      expect(icon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.color, AppColors.gray500);
    });

    testWidgets('renders favorite icon when recipe is favorited', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: ['1']));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final icon = find.byIcon(Icons.favorite);
      expect(icon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.color, AppColors.red);
    });

    testWidgets('uses custom color when provided', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: ['1']));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc, color: Colors.blue));

      final icon = find.byIcon(Icons.favorite);
      expect(icon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.color, Colors.blue);
    });

    testWidgets('uses default size when no size provided', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final icon = find.byIcon(Icons.favorite_border);
      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.size, 24.0);
    });

    testWidgets('uses custom size when provided', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc, size: 32.0));

      final icon = find.byIcon(Icons.favorite_border);
      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.size, 32.0);
    });

    testWidgets('has correct container styling', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, AppColors.white);
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('has AnimatedScale with correct scale values', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final animatedScale = find.byType(AnimatedScale);
      expect(animatedScale, findsOneWidget);

      final animatedScaleWidget = tester.widget<AnimatedScale>(animatedScale);
      expect(animatedScaleWidget.scale, 1.0); // Not favorited, so scale = 1.0
      expect(animatedScaleWidget.duration, const Duration(milliseconds: 200));
      expect(animatedScaleWidget.curve, Curves.easeInOut);
    });

    testWidgets('shows scaled up animation when favorited', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: ['1']));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final animatedScale = find.byType(AnimatedScale);
      expect(animatedScale, findsOneWidget);

      final animatedScaleWidget = tester.widget<AnimatedScale>(animatedScale);
      expect(animatedScaleWidget.scale, 1.2);
    });

    testWidgets('has AnimatedContainer with correct animations', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final animatedContainer = find.byType(AnimatedContainer);
      expect(animatedContainer, findsOneWidget);

      final animatedContainerWidget = tester.widget<AnimatedContainer>(animatedContainer);
      expect(animatedContainerWidget.duration, const Duration(milliseconds: 300));
      expect(animatedContainerWidget.curve, Curves.easeInOut);
    });

    testWidgets('dispatches ToggleFavorite event when tapped', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      final gestureDetector = find.byType(GestureDetector);
      await tester.tap(gestureDetector);
      await tester.pump();

      verify(mockFavoritesBloc.add(any)).called(1);
    });

    testWidgets('calls onTap callback when provided and tapped', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      bool onTapCalled = false;
      await tester.pumpWidget(
        buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc, onTap: () => onTapCalled = true),
      );

      final gestureDetector = find.byType(GestureDetector);
      await tester.tap(gestureDetector);
      await tester.pump();

      expect(onTapCalled, true);
    });

    testWidgets('calls onTap callback and dispatches ToggleFavorite event', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      bool onTapCalled = false;

      await tester.pumpWidget(
        buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc, onTap: () => onTapCalled = true),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback was called
      expect(onTapCalled, true);

      verify(
        mockFavoritesBloc.add(argThat(isA<ToggleFavorite>().having((e) => e.recipeId, 'recipeId', '1'))),
      ).called(1);
    });

    testWidgets('updates appearance when state changes on addig to favorites', (tester) async {
      final streamController = StreamController<FavoritesState>.broadcast();
      when(mockFavoritesBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: []));

      await tester.pumpWidget(buildTestWidget(recipeId: '1', favoritesBloc: mockFavoritesBloc));

      // Initially not favorited
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Change state to favorited
      when(mockFavoritesBloc.state).thenReturn(const FavoritesState(favoriteIds: ['1']));
      streamController.add(const FavoritesState(favoriteIds: ['1']));
      await tester.pump();

      // Should now show favorite icon
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      streamController.close();
    });
  });
}
