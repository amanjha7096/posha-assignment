// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Recipe Finder';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String get favoriteRecipesTitle => 'Favorite Recipes';

  @override
  String get retry => 'Retry';

  @override
  String get noRecipesFound => 'No recipes found';

  @override
  String get noFavoriteRecipesYet => 'No favorite recipes yet';

  @override
  String get addRecipesToFavoritesHint =>
      'Add recipes to favorites from the recipe details';

  @override
  String get filterRecipes => 'Filter Recipes';

  @override
  String get clear => 'Clear';

  @override
  String get category => 'Category';

  @override
  String get area => 'Area';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get recipeNotFound => 'Recipe not found';

  @override
  String get overview => 'Overview';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get instructions => 'Instructions';

  @override
  String get searchRecipe => 'Search recipe';
}
