import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:makeup/screens/subcategory_screen.dart';
import 'package:makeup/widgets/category_tile.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/subcategory_cubit.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<String>> subcategories = {};
  String searchQuery = '';

  Future<void> _fetchSubcategories(String category) async {
    final url =
        'https://makeup-api.herokuapp.com/api/v1/products.json?product_type=$category';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final Set<String> subcategorySet = data
            .map((product) => product['category']?.toString() ?? 'Unknown')
            .where((category) => category != 'Unknown')
            .toSet();

        if (mounted && subcategorySet.isNotEmpty) {
          setState(() {
            subcategories[category] = subcategorySet.toList();
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SubcategoryCubit(
                  products: data,
                  subcategories: subcategorySet.toList(),
                ),
                child: SubcategoryScreen(
                  category: category,
                  subcategories: subcategorySet.toList(),
                  products: data,
                ),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load subcategories for $category')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching subcategories')),
      );
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    final url =
        'https://makeup-api.herokuapp.com/api/v1/products/$productId.json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.pink[50],
          title: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _fetchSubcategories(value);
              }
            },
            decoration: InputDecoration(
              hintText: 'Search for products',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    CategoryTile(
                      label: 'Face',
                      imageUrl: 'lib/assets/images/face.jpg',
                      onTap: () {
                        _fetchSubcategories('foundation');
                      },
                    ),
                    CategoryTile(
                      label: 'Eyes',
                      imageUrl: 'lib/assets/images/eyes.jpg',
                      onTap: () {
                        _fetchSubcategories('eyeliner');
                      },
                    ),
                    CategoryTile(
                      label: 'Lips',
                      imageUrl: 'lib/assets/images/lips.jpg',
                      onTap: () {
                        _fetchSubcategories('lipstick');
                      },
                    ),
                    CategoryTile(
                      label: 'Blush',
                      imageUrl: 'lib/assets/images/blush.jpg',
                      onTap: () {
                        _fetchSubcategories('blush');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartAndFavoritesState>(
            builder: (context, state) {
          final cartItemCount = state.cartItems.length;
          final favoriteItemCount = state.favoriteItems.length;

          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: const Icon(
                    Icons.home,
                    size: 30,
                  ),
                  onTap: () {},
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.favorite,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritesScreen()),
                        );
                      },
                    ),
                    if (favoriteItemCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$favoriteItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
            ],
            selectedItemColor: Colors.pinkAccent[100],
            unselectedItemColor: Colors.grey,
          );
        }));
  }
}
