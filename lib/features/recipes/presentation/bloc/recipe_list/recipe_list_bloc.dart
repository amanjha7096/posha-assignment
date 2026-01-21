import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enums/view_mode.dart';
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
    on<SetPendingToSelected>(_onSetPendingToSelected);
    on<UpdatePendingCategories>(_onUpdatePendingCategories);
    on<UpdatePendingAreas>(_onUpdatePendingAreas);
    on<ApplyPendingFilters>(_onApplyPendingFilters);
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
      emit(state.copyWith(recipes: recipes, filteredRecipes: recipes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
      emit(state.copyWith(filteredRecipes: recipes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSetPendingToSelected(SetPendingToSelected event, Emitter<RecipeListState> emit) {
    emit(
      state.copyWith(pendingSelectedCategories: state.selectedCategories, pendingSelectedAreas: state.selectedAreas),
    );
  }

  void _onUpdatePendingCategories(UpdatePendingCategories event, Emitter<RecipeListState> emit) {
    emit(state.copyWith(pendingSelectedCategories: event.categories));
  }

  void _onUpdatePendingAreas(UpdatePendingAreas event, Emitter<RecipeListState> emit) {
    emit(state.copyWith(pendingSelectedAreas: event.areas));
  }

  void _onApplyPendingFilters(ApplyPendingFilters event, Emitter<RecipeListState> emit) {
    final filtered = _applyFilters(
      recipes: state.recipes,
      categories: state.pendingSelectedCategories,
      areas: state.pendingSelectedAreas,
    );
    emit(
      state.copyWith(
        selectedCategories: state.pendingSelectedCategories,
        selectedAreas: state.pendingSelectedAreas,
        filteredRecipes: filtered,
      ),
    );
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<RecipeListState> emit) {
    final newMode = state.viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    emit(state.copyWith(viewMode: newMode));
  }

  void _onSortRecipes(SortRecipes event, Emitter<RecipeListState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
  }

  void _onClearFilters(ClearFilters event, Emitter<RecipeListState> emit) {
    emit(
      state.copyWith(
        selectedCategories: [],
        selectedAreas: [],
        pendingSelectedCategories: [],
        pendingSelectedAreas: [],
        filteredRecipes: state.recipes,
      ),
    );
  }

  List<Recipe> _applyFilters({
    required List<Recipe> recipes,
    List<String> categories = const [],
    List<String> areas = const [],
  }) {
    return recipes.where((recipe) {
      final matchesCategory = categories.isEmpty || categories.contains(recipe.category);
      final matchesArea = areas.isEmpty || areas.contains(recipe.area);
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
