// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class ShoppingList {
  final String id;
  final String name;
  final String quantity;

  ShoppingList({
    required this.id,
    required this.name,
    required this.quantity,
  });

  ShoppingList copyWith({
    String? id,
    String? name,
    String? quantity,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingList.fromJson(String source) =>
      ShoppingList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ShoppingListItem(id: $id, name: $name, quantity: $quantity)';

  @override
  bool operator ==(covariant ShoppingList other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ quantity.hashCode;
}
