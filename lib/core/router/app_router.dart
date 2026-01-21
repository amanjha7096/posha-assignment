import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/recipes/domain/usecases/get_recipe_details.dart';
import '../../features/recipes/presentation/bloc/recipe_list/recipe_list_bloc.dart';
import '../../features/recipes/presentation/pages/recipe_list_page.dart';
import '../../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../../features/recipes/presentation/pages/favorites_page.dart';
import '../../features/recipes/presentation/bloc/favorites/favorites_bloc.dart';
import '../../features/recipes/presentation/bloc/recipe_detail/recipe_detail_bloc.dart';
import '../di/injection_container.dart' as di;

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const RecipeListPage(),
        routes: [
          GoRoute(
            path: 'recipe/:id',
            name: 'recipe_detail',
            pageBuilder: (context, state) {
              final recipeId = state.pathParameters['id']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: BlocProvider(
                  create: (context) =>
                      RecipeDetailBloc(di.sl<GetRecipeDetails>(), di.sl<RecipeRepository>())
                        ..add(LoadRecipeDetails(recipeId)),
                  child: RecipeDetailPage(recipeId: recipeId),
                ),
                transitionDuration: const Duration(milliseconds: 300),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.8,
                      end: 1.0,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInExpo)),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
              );
            },
          ),
          GoRoute(path: 'favorites', name: 'favorites', builder: (context, state) => const FavoritesPage()),
        ],
      ),
    ],
  );
}
