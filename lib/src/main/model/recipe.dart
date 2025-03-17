// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum RecipeCategory { normal, cluckmazing }

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  Ingredient copyWith({String? name, String? quantity}) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'quantity': quantity};
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredient.fromJson(String source) =>
      Ingredient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ingredient(name: $name, quantity: $quantity)';

  @override
  bool operator ==(covariant Ingredient other) {
    if (identical(this, other)) return true;

    return other.name == name && other.quantity == quantity;
  }

  @override
  int get hashCode => name.hashCode ^ quantity.hashCode;
}

class RecipeStep {
  final String description;
  final int? timer;

  RecipeStep({required this.description, this.timer});

  RecipeStep copyWith({String? description, int? timer}) {
    return RecipeStep(
      description: description ?? this.description,
      timer: timer ?? this.timer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'description': description, 'timer': timer};
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      description: map['description'] as String,
      timer: map['timer'] != null ? map['timer'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeStep.fromJson(String source) =>
      RecipeStep.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecipeStep(description: $description, timer: $timer)';

  @override
  bool operator ==(covariant RecipeStep other) {
    if (identical(this, other)) return true;

    return other.description == description && other.timer == timer;
  }

  @override
  int get hashCode => description.hashCode ^ timer.hashCode;
}

class Recipe {
  final String id;
  final String title;
  final RecipeCategory category;
  final bool isLocked;
  final int requiredCountToUnlock;
  final bool isCompleted;
  final bool isFavorite;
  final int difficulty;
  final int spicy;
  final int timeInMinutes;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final String image;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    this.isLocked = false,
    required this.requiredCountToUnlock,
    this.spicy = 0,
    this.timeInMinutes = 0,

    this.isCompleted = false,
    this.isFavorite = false,
    this.difficulty = 1,
    required this.ingredients,
    required this.steps,
    required this.image,
  });

  Recipe copyWith({
    String? id,
    String? title,
    RecipeCategory? category,
    bool? isLocked,
    int? requiredCountToUnlock,
    int? spicy,
    int? timeInMinutes,

    bool? isCompleted,
    bool? isFavorite,
    int? difficulty,
    List<Ingredient>? ingredients,
    List<RecipeStep>? steps,
    String? image,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      spicy: spicy ?? this.spicy,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,

      isLocked: isLocked ?? this.isLocked,
      requiredCountToUnlock:
          requiredCountToUnlock ?? this.requiredCountToUnlock,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category.name,
      'isLocked': isLocked,
      'requiredCountToUnlock': requiredCountToUnlock,
      'isCompleted': isCompleted,
      'isFavorite': isFavorite,
      'difficulty': difficulty,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'image': image,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      category: RecipeCategory.values.firstWhere(
        (e) => e.name == map['category'],
      ),
      isLocked: map['isLocked'] as bool,
      requiredCountToUnlock: map['requiredCountToUnlock'] as int,
      isCompleted: map['isCompleted'] as bool,
      isFavorite: map['isFavorite'] as bool,
      difficulty: map['difficulty'] as int,
      image: map['image'] as String,
      ingredients: List<Ingredient>.from(
        (map['ingredients'] as List<dynamic>).map<Ingredient>(
          (x) => Ingredient.fromMap(x as Map<String, dynamic>),
        ),
      ),
      steps: List<RecipeStep>.from(
        (map['steps'] as List<dynamic>).map<RecipeStep>(
          (x) => RecipeStep.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) =>
      Recipe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, category: $category, isLocked: $isLocked, requiredCountToUnlock: $requiredCountToUnlock, isCompleted: $isCompleted, isFavorite: $isFavorite, difficulty: $difficulty, ingredients: $ingredients, steps: $steps)';
  }

  @override
  bool operator ==(covariant Recipe other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.category == category &&
        other.isLocked == isLocked &&
        other.requiredCountToUnlock == requiredCountToUnlock &&
        other.isCompleted == isCompleted &&
        other.isFavorite == isFavorite &&
        other.difficulty == difficulty &&
        other.image == image &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.steps, steps);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        category.hashCode ^
        isLocked.hashCode ^
        requiredCountToUnlock.hashCode ^
        isCompleted.hashCode ^
        isFavorite.hashCode ^
        difficulty.hashCode ^
        ingredients.hashCode ^
        steps.hashCode;
  }
}
