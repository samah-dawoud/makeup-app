import 'package:bloc/bloc.dart';
import 'package:makeup/cubit/subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  final List<dynamic> products;
  final List<String> subcategories;

  SubcategoryCubit({required this.products, required this.subcategories}) : super(SubcategoryInitial()) {
    if (subcategories.isNotEmpty) {
      filterProducts(subcategories[0]);
    }
  }

  void filterProducts(String subcategory) {
    emit(SubcategoryLoading());

    try {
      final filteredProducts = products
          .where((product) =>
      product['category'] == subcategory &&
          product['image_link'] != null &&
          product['price'] != '0.0')
          .toList();
      emit(SubcategoryLoaded(filteredProducts));
    } catch (e) {
      emit(SubcategoryError('An error occurred while filtering products'));
    }
  }
}
