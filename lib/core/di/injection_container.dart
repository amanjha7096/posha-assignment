import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../features/recipes/data/datasources/remote/recipe_remote_data_source.dart';
import '../../features/recipes/data/datasources/local/recipe_local_data_source.dart';
import '../../features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/recipes/domain/usecases/check_favorite_status.dart';
import '../../features/recipes/domain/usecases/get_recipes.dart';
import '../../features/recipes/domain/usecases/get_categories.dart';
import '../../features/recipes/domain/usecases/get_areas.dart';
import '../../features/recipes/domain/usecases/get_recipe_details.dart';
import '../../features/recipes/domain/usecases/get_favorites.dart';
import '../../features/recipes/domain/usecases/toggle_favorite_status.dart';
import '../../features/recipes/presentation/bloc/favorites/favorites_bloc.dart';
import '../../features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';
import '../../features/recipes/presentation/bloc/recipe_detail/recipe_detail_bloc.dart';

import '../network/api_client.dart';
import '../utils/hive_helper.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  // External dependencies
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DefaultCacheManager());

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Hive
  await HiveHelper.init();
  sl.registerLazySingleton(() => HiveHelper.favoritesBoxInstance, instanceName: 'favorites');
  sl.registerLazySingleton(() => HiveHelper.cacheBoxInstance, instanceName: 'cache');

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(
      sl(instanceName: 'favorites'),
      sl(instanceName: 'cache'),
    ),
  );

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRecipes(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetAreas(sl()));
  sl.registerLazySingleton(() => GetRecipeDetails(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => CheckFavorite(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteStatus(sl()));

  // BLoCs
  sl.registerFactory(() => RecipeListBloc(sl(), sl(), sl()));
  sl.registerFactory(() => RecipeDetailBloc(sl(), sl()));
  sl.registerFactory(() => FavoritesBloc(sl(), sl()));
}
