part of 'favorites_bloc.dart';

class FavoritesState {
  final bool isLoading;
  final List<String> favoriteIds;
  final String? error;

  const FavoritesState({
    this.isLoading = false,
    this.favoriteIds = const [],
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<String>? favoriteIds,
    String? error,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      error: error ?? this.error,
    );
  }
}
