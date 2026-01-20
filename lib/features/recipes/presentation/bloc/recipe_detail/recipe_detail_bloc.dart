import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/usecases/get_recipe_details.dart';
import '../../../domain/repositories/recipe_repository.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final GetRecipeDetails getRecipeDetails;
  final RecipeRepository repository;

  RecipeDetailBloc(this.getRecipeDetails, this.repository) : super(const RecipeDetailState()) {
    on<LoadRecipeDetails>(_onLoadRecipeDetails);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadRecipeDetails(LoadRecipeDetails event, Emitter<RecipeDetailState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final recipe = await getRecipeDetails(event.recipeId);
      final isFavorite = await repository.isFavorite(event.recipeId);
      emit(state.copyWith(
        recipe: recipe,
        isFavorite: isFavorite,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<RecipeDetailState> emit) async {
    try {
      if (state.isFavorite) {
        await repository.removeFromFavorites(event.recipeId);
        emit(state.copyWith(isFavorite: false));
      } else {
        await repository.addToFavorites(event.recipeId);
        emit(state.copyWith(isFavorite: true));
      }
    } catch (e) {
      // Handle error if needed
    }
  }
}
