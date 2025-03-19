import 'package:cluckmazing_recipe/src/core/dependency_injection.dart';
import 'package:cluckmazing_recipe/src/main/model/history.dart';
import 'package:cluckmazing_recipe/src/main/model/recipe.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';
import 'package:cluckmazing_recipe/src/main/repository/shopping_repository.dart';
import 'package:cluckmazing_recipe/src/main/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final RecipeRepository recipeRepository = locator<RecipeRepository>();
  final ShoppingListRepository shoppingRepository =
      locator<ShoppingListRepository>();

  AppBloc() : super(AppLoading()) {
    on<LoadDataEvent>(_onLoadData);
    on<UpdateRecipeEvent>(_onUpdateRecipe);
    on<AddShoppingItemEvent>(_onAddShoppingItem);
    on<RemoveShoppingItemEvent>(_onRemoveShoppingItem);
    on<RemoveAllShoppingItemsEvent>(_removeAllShoppingItems);
    on<SaveHistoryItemEvent>(_saveHistoryItem);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final loadedRecipes = await recipeRepository.load();
      final loadedShoppingList = await shoppingRepository.load();
      final loadedHistory = await recipeRepository.loadHistory();
      emit(
        AppLoaded(
          recipes: loadedRecipes,
          shoppingList: loadedShoppingList,
          history: loadedHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onUpdateRecipe(
    UpdateRecipeEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      await recipeRepository.update(event.recipe);
      List<Recipe> updatedRecipes = await recipeRepository.load();
      final complitedRecipes =
          updatedRecipes.where((r) => r.isCompleted).toList();
      if (updatedRecipes.any(
        (test) => test.requiredCountToUnlock == complitedRecipes.length,
      )) {
        final updatedRecipe = updatedRecipes.firstWhere(
          (test) => test.requiredCountToUnlock == complitedRecipes.length,
        );
        await recipeRepository.update(updatedRecipe.copyWith(isLocked: false));
        updatedRecipes = await recipeRepository.load();
      }

      final currentShoppingList = (state as AppLoaded).shoppingList;
      final currentHistory = (state as AppLoaded).history;
      emit(
        AppLoaded(
          recipes: updatedRecipes,
          shoppingList: currentShoppingList,
          history: currentHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onAddShoppingItem(
    AddShoppingItemEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      await shoppingRepository.save(event.item);
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      final currentHistory = (state as AppLoaded).history;
      emit(
        AppLoaded(
          recipes: currentRecipes,
          shoppingList: updatedList,
          history: currentHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onRemoveShoppingItem(
    RemoveShoppingItemEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      await shoppingRepository.remove(event.item);
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      final currentHistory = (state as AppLoaded).history;
      emit(
        AppLoaded(
          recipes: currentRecipes,
          shoppingList: updatedList,
          history: currentHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _removeAllShoppingItems(
    RemoveAllShoppingItemsEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      for (var item in (state as AppLoaded).shoppingList) {
        await shoppingRepository.remove(item);
      }
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      final currentHistory = (state as AppLoaded).history;
      emit(
        AppLoaded(
          recipes: currentRecipes,
          shoppingList: updatedList,
          history: currentHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _saveHistoryItem(
    SaveHistoryItemEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      final historyItem = History(
        dateTime: DateTime.now(),
        shoppingList: event.item,
      );
      await recipeRepository.saveHistory(historyItem);
      await shoppingRepository.remove(event.item);
      final updatedHistory = await recipeRepository.loadHistory();
      final currentRecipes = (state as AppLoaded).recipes;
      final updatedList = await shoppingRepository.load();

      emit(
        AppLoaded(
          recipes: currentRecipes,
          shoppingList: updatedList,
          history: updatedHistory,
        ),
      );
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }
}
