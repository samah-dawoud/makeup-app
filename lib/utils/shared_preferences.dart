import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String _cartKey = 'cart';
  static const String _favoritesKey = 'favorites';

  // Load cart items
  static Future<List<dynamic>> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCart = prefs.getStringList(_cartKey);
    if (savedCart != null) {
      return savedCart.map((productJson) => jsonDecode(productJson)).toList();
    }
    return [];
  }

  // Save cart items
  static Future<void> saveCart(List<dynamic> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartStringList = cart.map((product) => jsonEncode(product)).toList();
    await prefs.setStringList(_cartKey, cartStringList);
  }

  // Load favorite items
  static Future<List<dynamic>> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      return savedFavorites.map((productJson) => jsonDecode(productJson)).toList();
    }
    return [];
  }

  // Save favorite items
  static Future<void> saveFavorites(List<dynamic> favorites) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritesStringList = favorites.map((product) => jsonEncode(product)).toList();
    await prefs.setStringList(_favoritesKey, favoritesStringList);
  }
}
