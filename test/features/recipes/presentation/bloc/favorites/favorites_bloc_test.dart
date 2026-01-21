import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:recipe/core/enums/view_mode.dart';
import 'package:recipe/features/recipes/domain/usecases/get_favorites.dart';
import 'package:recipe/features/recipes/domain/usecases/toggle_favorite_status.dart';
import 'package:recipe/features/recipes/presentation/bloc/favorites/favorites_bloc.dart';

@GenerateMocks([GetFavorites, ToggleFavoriteStatus])
import 'favorites_bloc_test.mocks.dart';

void main() {
  late FavoritesBloc bloc;
  late MockGetFavorites mockGetFavorites;
  late MockToggleFavoriteStatus mockToggleFavoriteStatus;

  setUp(() {
    mockGetFavorites = MockGetFavorites();
    mockToggleFavoriteStatus = MockToggleFavoriteStatus();
    bloc = FavoritesBloc(mockGetFavorites, mockToggleFavoriteStatus);
  });

  tearDown(() {
    bloc.close();
  });

  group('FavoritesBloc', () {
    final testFavoriteIds = ['1', '2', '3'];

    blocTest<FavoritesBloc, FavoritesState>(
      'loads favorites on initialization',
      build: () {
        when(mockGetFavorites()).thenAnswer((_) async => testFavoriteIds);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavorites()),

      expect: () => [
        isA<FavoritesState>().having((state) => state.isLoading, 'isLoading', true),

        isA<FavoritesState>()
            .having((state) => state.isLoading, 'isLoading', false)
            .having((state) => state.favoriteIds, 'favoriteIds', testFavoriteIds),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'emits loading and then favorites when LoadFavorites is added',
      build: () {
        when(mockGetFavorites()).thenAnswer((_) async => testFavoriteIds);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavorites()),
      expect: () => [
        isA<FavoritesState>().having((state) => state.isLoading, 'isLoading', true),
        isA<FavoritesState>()
            .having((state) => state.favoriteIds, 'favoriteIds', testFavoriteIds)
            .having((state) => state.isLoading, 'isLoading', false),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'adds to favorites when ToggleFavorite is called on non-favorite',
      build: () {
        when(mockToggleFavoriteStatus('4', false)).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(ToggleFavorite('4')),
      expect: () => [
        isA<FavoritesState>().having((state) => state.favoriteIds, 'favoriteIds', ['4']),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'removes from favorites when ToggleFavorite is called on favorite',
      build: () {
        bloc.emit(FavoritesState(favoriteIds: ['1', '2', '3']));
        when(mockToggleFavoriteStatus('2', true)).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(ToggleFavorite('2')),
      expect: () => [
        isA<FavoritesState>().having((state) => state.favoriteIds, 'favoriteIds', ['1', '3']),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'toggles view mode when ToggleViewMode is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ToggleViewMode()),
      expect: () => [isA<FavoritesState>().having((state) => state.viewMode, 'viewMode', ViewMode.list)],
    );

    test('handles error when loading favorites fails', () async {
      when(mockGetFavorites()).thenThrow(Exception('Load error'));

      bloc.add(LoadFavorites());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<FavoritesState>().having((state) => state.isLoading, 'isLoading', true),
          isA<FavoritesState>()
              .having((state) => state.isLoading, 'isLoading', false)
              .having((state) => state.error, 'error', 'Exception: Load error'),
        ]),
      );
    });
  });
}
