import '../repositories/recipe_repository.dart';

class GetAreas {
  final RecipeRepository repository;

  GetAreas(this.repository);

  Future<List<String>> call() async {
    return await repository.getAreas();
  }
}
