import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/repositories/recipe_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final RecipeRepository repository;

  FavoritesBloc(this.getFavorites, this.repository) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteFromList>(_onToggleFavoriteFromList);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final favorites = await getFavorites();
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

  Future<void> _onToggleFavoriteFromList(ToggleFavoriteFromList event, Emitter<FavoritesState> emit) async {
    try {
      await repository.removeFromFavorites(event.recipeId);
      final updatedFavorites = state.favoriteIds.where((id) => id != event.recipeId).toList();
      emit(state.copyWith(favoriteIds: updatedFavorites));
    } catch (e) {
      // Handle error if needed
    }
  }
}
