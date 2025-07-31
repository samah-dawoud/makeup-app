import 'package:flutter/foundation.dart';

@immutable
abstract class SubcategoryState {
  get cartItems => null;

  get favoriteItems => null;
}

class SubcategoryInitial extends SubcategoryState {}

class SubcategoryLoading extends SubcategoryState {}

class SubcategoryLoaded extends SubcategoryState {
  final List<dynamic> filteredProducts;

  SubcategoryLoaded(this.filteredProducts);
}

class SubcategoryError extends SubcategoryState {
  final String message;

  SubcategoryError(this.message);
}
