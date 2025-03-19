part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends AppEvent {}

class UpdateRecipeEvent extends AppEvent {
  final Recipe recipe;
  const UpdateRecipeEvent(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class AddShoppingItemEvent extends AppEvent {
  final ShoppingList item;
  const AddShoppingItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveShoppingItemEvent extends AppEvent {
  final ShoppingList item;
  const RemoveShoppingItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class SaveHistoryItemEvent extends AppEvent {
  final ShoppingList item;
  const SaveHistoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveAllShoppingItemsEvent extends AppEvent {}
