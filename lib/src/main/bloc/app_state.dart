part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<Recipe> recipes;
  final List<ShoppingList> shoppingList;
  final List<History> history ;
  

  const AppLoaded({
    required this.recipes,
    required this.history,
    required this.shoppingList,
  });

  @override
  List<Object?> get props => [recipes, shoppingList, history];
}

class AppError extends AppState {
  final String error;

  const AppError(this.error);

  @override
  List<Object?> get props => [error];
}