part of 'favorites_bloc.dart';

class FavoritesState {
  final bool isLoading;
  final List<String> favoriteIds;
  final String? error;
  final ViewMode viewMode;

  const FavoritesState({
    this.isLoading = false,
    this.favoriteIds = const [],
    this.error,
    this.viewMode = ViewMode.grid,
  });

  //check if recipe is marked as favorite
  bool isFavorite(String id) => favoriteIds.contains(id);

  FavoritesState copyWith({
    bool? isLoading,
    List<String>? favoriteIds,
    String? error,
    ViewMode? viewMode,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      error: error ?? this.error,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}
