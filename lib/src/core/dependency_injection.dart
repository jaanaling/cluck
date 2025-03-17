
import 'package:cluckmazing_recipe/src/main/repository/shopping_repository.dart';
import 'package:get_it/get_it.dart';

import '../main/repository/user_repository.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerLazySingleton(() => ShoppingListRepository());
  locator.registerLazySingleton(() => RecipeRepository());

}
