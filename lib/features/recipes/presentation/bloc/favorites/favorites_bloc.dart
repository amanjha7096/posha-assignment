import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite_status.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavoriteStatus toggleFavoriteStatus;

  FavoritesBloc(this.getFavorites, this.toggleFavoriteStatus) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    //calling load favorites to store list in state on init
    add(LoadFavorites());
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final favorites = await getFavorites();
      print(favorites);
      emit(state.copyWith(
        favoriteIds: favorites,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final isCurrentlyFavorite = state.favoriteIds.contains(event.recipeId);
      await toggleFavoriteStatus(event.recipeId, isCurrentlyFavorite);

      // Update the favoriteIds list
      final updatedFavorites = isCurrentlyFavorite
          ? state.favoriteIds.where((id) => id != event.recipeId).toList()
          : [...state.favoriteIds, event.recipeId];

      emit(state.copyWith(favoriteIds: updatedFavorites));
    } catch (e) {
      // Handle error if needed
    }
  }
}
