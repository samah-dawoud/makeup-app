import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makeup/models/product_model.dart';
import 'package:makeup/utils/shared_preferences.dart';

// Define a class to hold both cart and favorites data
class CartAndFavoritesState {
  final List<Product> cartItems;
  final List<Product> favoriteItems;

  CartAndFavoritesState({
    required this.cartItems,
    required this.favoriteItems,
  });

  // Helper methods for convenience
  bool isProductInCart(Product product) => cartItems.contains(product);
  bool isProductFavorite( product) => favoriteItems.contains(product);
}

class CartCubit extends Cubit<CartAndFavoritesState> {
  CartCubit() : super(CartAndFavoritesState(cartItems: [], favoriteItems: [])) {
    loadCartAndFavoritesFromPreferences();
  }

  // Toggle cart item
Future<void> toggleCartItem(Product product) async {
  final currentCartItems = state.cartItems;
  List<Product> updatedCart;

  if (currentCartItems.contains(product)) {
    updatedCart = List.from(currentCartItems)..remove(product);
  } else {
    updatedCart = List.from(currentCartItems)..add(product);
  }

  emit(CartAndFavoritesState(
    cartItems: updatedCart,
    favoriteItems: state.favoriteItems,
  ));
  await _saveCart(updatedCart.map((product) => product.toMap()).toList());
}

  // Toggle favorite item
  Future<void> toggleFavorite(Product product) async {
  final currentFavorites = state.favoriteItems;
  List<Product> updatedFavorites;

  if (currentFavorites.contains(product)) {
    updatedFavorites = List.from(currentFavorites)..remove(product);
  } else {
    updatedFavorites = List.from(currentFavorites)..add(product);
  }

  emit(CartAndFavoritesState(
    cartItems: state.cartItems,
    favoriteItems: updatedFavorites,
  ));
  await _saveFavorites(updatedFavorites.map((product) => product.toMap()).toList());
}

  // Check if item is in favorites
  bool isFavorite(Product product) {
    return state.favoriteItems.contains(product);
  }

  // Calculate total price
  double getTotalPrice() {
     return state.cartItems.fold(0.0, (total, product) => total + (product.price));
  }

  // Load cart and favorites from shared preferences
  Future<void> loadCartAndFavoritesFromPreferences() async {
  try {
    final cartMaps = await SharedPreferencesUtil.loadCart();
    final favoritesMaps = await SharedPreferencesUtil.loadFavorites();

    final cartProducts = cartMaps.map((map) => Product.fromJson(map)).toList();
    final favoriteProducts = favoritesMaps.map((map) => Product.fromJson(map)).toList();

    emit(CartAndFavoritesState(
      cartItems: cartProducts,
      favoriteItems: favoriteProducts,
    ));
  } catch (error) {
    emit(CartAndFavoritesState(
      cartItems: [],
      favoriteItems: [],
    ));
  }
}
  // Save cart to shared preferences
  Future<void> _saveCart(List<dynamic> updatedCart) async {
    try {
      await SharedPreferencesUtil.saveCart(updatedCart);
    } catch (error) {
      // Handle error
    }
  }

  // Save favorites to shared preferences
  Future<void> _saveFavorites(List<dynamic> updatedFavorites) async {
    try {
      await SharedPreferencesUtil.saveFavorites(updatedFavorites);
    } catch (error) {
      // Handle error
    }
  }
}
