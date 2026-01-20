import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_recipes.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_areas.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final GetRecipes getRecipes;
  final GetCategories getCategories;
  final GetAreas getAreas;

  RecipeListBloc(this.getRecipes, this.getCategories, this.getAreas) : super(const RecipeListState()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<SearchRecipes>(_onSearchRecipes);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByArea>(_onFilterByArea);
    on<ToggleViewMode>(_onToggleViewMode);
    on<SortRecipes>(_onSortRecipes);
    on<ClearFilters>(_onClearFilters);
    on<LoadCategories>(_onLoadCategories);
    on<LoadAreas>(_onLoadAreas);
  }

  Future<void> _onLoadRecipes(LoadRecipes event, Emitter<RecipeListState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final recipes = await getRecipes();
      emit(state.copyWith(
        recipes: recipes,
        filteredRecipes: recipes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSearchRecipes(SearchRecipes event, Emitter<RecipeListState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredRecipes: state.recipes));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final recipes = await getRecipes(query: event.query);
      emit(state.copyWith(
        recipes: recipes,
        filteredRecipes: recipes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<RecipeListState> emit) {
    final filtered = _applyFilters(
      recipes: state.recipes,
      category: event.category,
      area: state.selectedArea,
    );
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredRecipes: filtered,
    ));
  }

  void _onFilterByArea(FilterByArea event, Emitter<RecipeListState> emit) {
    final filtered = _applyFilters(
      recipes: state.recipes,
      category: state.selectedCategory,
      area: event.area,
    );
    emit(state.copyWith(
      selectedArea: event.area,
      filteredRecipes: filtered,
    ));
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<RecipeListState> emit) {
    final newMode = state.viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    emit(state.copyWith(viewMode: newMode));
  }

  void _onSortRecipes(SortRecipes event, Emitter<RecipeListState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
  }

  void _onClearFilters(ClearFilters event, Emitter<RecipeListState> emit) {
    emit(state.copyWith(
      selectedCategory: null,
      selectedArea: null,
      filteredRecipes: state.recipes,
    ));
  }

  List<Recipe> _applyFilters({
    required List<Recipe> recipes,
    String? category,
    String? area,
  }) {
    return recipes.where((recipe) {
      final matchesCategory = category == null || recipe.category == category;
      final matchesArea = area == null || recipe.area == area;
      return matchesCategory && matchesArea;
    }).toList();
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<RecipeListState> emit) async {
    try {
      final categories = await getCategories();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      // Categories are optional, don't show error
    }
  }

  Future<void> _onLoadAreas(LoadAreas event, Emitter<RecipeListState> emit) async {
    try {
      final areas = await getAreas();
      emit(state.copyWith(areas: areas));
    } catch (e) {
      // Areas are optional, don't show error
    }
  }
}
