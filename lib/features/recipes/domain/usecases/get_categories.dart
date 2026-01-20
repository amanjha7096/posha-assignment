import '../entities/category.dart';
import '../repositories/recipe_repository.dart';

class GetCategories {
  final RecipeRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}
