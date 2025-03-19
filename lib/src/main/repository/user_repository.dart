import 'package:cluckmazing_recipe/src/core/utils/json_loader.dart';
import 'package:cluckmazing_recipe/src/main/model/history.dart';
import 'package:cluckmazing_recipe/src/main/model/recipe.dart';

/// Репозиторий для советов.
class RecipeRepository {
  final String key = 'recipe';

  Future<List<Recipe>> load() {
    return JsonLoader.loadData<Recipe>(
      key,
      'assets/json/$key.json',
      (json) => Recipe.fromMap(json),
    );
  }

  Future<void> update(Recipe updated) {
    return JsonLoader.modifyDataList<Recipe>(
      key,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        final index = itemList.indexWhere((d) => d.id == updated.id);
        if (index != -1) {
          itemList[index] = updated;
        }
      },
    );
  }

  Future<List<History>> loadHistory() {
    return JsonLoader.loadData<History>(
      "history",
      'assets/json/history.json',
      (json) => History.fromMap(json),
    );
  }

  Future<void> saveHistory(History item) {
    return JsonLoader.saveData<History>(
      "history",
      item,
      () async => await loadHistory(),
      (item) => item.toMap(),
    );
  }

  Future<void> save(Recipe item) {
    return JsonLoader.saveData<Recipe>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> remove(Recipe item) {
    return JsonLoader.removeData<Recipe>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }
}
