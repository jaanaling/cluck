

import 'package:cluckmazing_recipe/src/core/utils/json_loader.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';

class ShoppingListRepository {
  final String key = 'shopping';

  Future<List<ShoppingList>> load() {
    return JsonLoader.loadData<ShoppingList>(
      key,
      'assets/json/$key.json',
      (json) => ShoppingList.fromMap(json),
    );
  }

  Future<void> update(ShoppingList updated) async {
    return JsonLoader.modifyDataList<ShoppingList>(
      key,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        itemList.first = updated;
      },
    );
  }

  Future<void> save(ShoppingList item) {
    return JsonLoader.saveData<ShoppingList>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> remove(ShoppingList item) {
    return JsonLoader.removeData<ShoppingList>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }
}
