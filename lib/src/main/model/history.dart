// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';

class History {
  DateTime dateTime;
  ShoppingList shoppingList;

  History({required this.dateTime, required this.shoppingList});

  History copyWith({DateTime? dateTime, ShoppingList? shoppingList}) {
    return History(
      dateTime: dateTime ?? this.dateTime,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateTime': dateTime.millisecondsSinceEpoch,
      'shoppingList': shoppingList.toMap(),
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      shoppingList: ShoppingList.fromMap(
        map['shoppingList'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'History(dateTime: $dateTime, shoppingList: $shoppingList)';

  @override
  bool operator ==(covariant History other) {
    if (identical(this, other)) return true;

    return other.dateTime == dateTime && other.shoppingList == shoppingList;
  }

  @override
  int get hashCode => dateTime.hashCode ^ shoppingList.hashCode;
}
