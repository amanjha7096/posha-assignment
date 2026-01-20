part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavoriteFromList extends FavoritesEvent {
  final String recipeId;

  ToggleFavoriteFromList(this.recipeId);
}
