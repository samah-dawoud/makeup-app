import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makeup/screens/favourite_screen.dart';
import 'package:makeup/screens/product_details_screen.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/subcategory_cubit.dart';
import '../cubit/subcategory_state.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';

class SubcategoryScreen extends StatelessWidget {
  final String category;
  final List<String> subcategories;
  final List<dynamic> products;

  const SubcategoryScreen({
    super.key,
    required this.category,
    required this.subcategories,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SubcategoryCubit(
              products: products,
              subcategories: subcategories,
            ),
        child: BlocConsumer<SubcategoryCubit, SubcategoryState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(category),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavoritesScreen()),
                          );
                        },
                        icon: const Icon(Icons.favorite)),
                  ],
                ),
                body: BlocProvider(
                    create: (context) => SubcategoryCubit(
                          products: products,
                          subcategories: subcategories,
                        ),
                    child: BlocConsumer<SubcategoryCubit, SubcategoryState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return BlocProvider.value(
                          value: context.read<CartCubit>(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Subcategories',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: subcategories.map((subcategory) {
                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<SubcategoryCubit>()
                                              .filterProducts(subcategory);
                                        },
                                        child: Container(
                                          width: 110,
                                          height: 50,
                                          padding: const EdgeInsets.all(8.0),
                                          margin:
                                              const EdgeInsets.only(right: 8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.pinkAccent[100],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              subcategory,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Products',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: BlocBuilder<SubcategoryCubit,
                                      SubcategoryState>(
                                    builder: (context, state) {
                                      if (state is SubcategoryLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is SubcategoryLoaded) {
                                        final filteredProducts =
                                            state.filteredProducts;
                                        return filteredProducts.isEmpty
                                            ? const Center(
                                                child: Text(
                                                    'No products available'))
                                            : ListView.builder(
                                                itemCount:
                                                    filteredProducts.length,
                                                itemBuilder: (context, index) {
                                                  final productData =
                                                      filteredProducts[index];

                                                  // Construct the Product object from the API data
                                                  final product = Product(
                                                    name: productData['name'] ??
                                                        'Unknown',
                                                    brand:
                                                        productData['brand'] ??
                                                            'Unknown',
                                                    price: productData[
                                                                'price'] !=
                                                            null
                                                        ? double.tryParse(
                                                                productData[
                                                                        'price']
                                                                    .toString()) ??
                                                            0.0
                                                        : 0.0,
                                                    rating: productData[
                                                                'rating'] !=
                                                            null
                                                        ? double.tryParse(
                                                                productData[
                                                                        'rating']
                                                                    .toString()) ??
                                                            0.0
                                                        : 0.0,
                                                    imageLink: productData[
                                                            'image_link'] ??
                                                        '',
                                                    colors: productData[
                                                                'product_colors'] !=
                                                            null
                                                        ? (productData[
                                                                    'product_colors']
                                                                as List)
                                                            .map((color) =>
                                                                color['colour_name']
                                                                    as String)
                                                            .toList()
                                                        : [],
                                                    description: productData[
                                                            'description'] ??
                                                        'No description available',
                                                  );

                                                  return Card(
                                                    color: Colors.pink[50],
                                                    elevation: 5,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: ListTile(
                                                      leading: product.imageLink.isNotEmpty
                                                            ? SizedBox(
                                                                width: 80,
                                                                height: 80,
                                                                child: Image.network(
                                                                  product.imageLink,
                                                                  fit: BoxFit.cover,
                                                                  errorBuilder: (context, error, stackTrace) {
                                                                    return const Icon(Icons.error);
                                                                  },
                                                                ),
                                                              )
                                                            : const Icon(Icons.image),
                                                      title: Text(product.name),
                                                      subtitle: Text(
                                                          '\$${product.price}'),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          BlocBuilder<CartCubit, CartAndFavoritesState>(
                                                          builder: (context, state) {
                                                            final isInCart = state.isProductInCart(product);
                                                            return IconButton(
                                                              icon: Icon(
                                                                Icons.add_shopping_cart,
                                                                color: isInCart ? Colors.pink : Colors.grey,
                                                              ),
                                                              onPressed: () {
                                                                context.read<CartCubit>().toggleCartItem(product);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        BlocBuilder<CartCubit, CartAndFavoritesState>(
                                                        builder: (context, state) {
                                                          final isFavorite = state.isProductFavorite(product);
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.favorite,
                                                              color: isFavorite ? Colors.pink : Colors.grey,
                                                            ),
                                                            onPressed: () {
                                                              context.read<CartCubit>().toggleFavorite(product);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                        ],
                                                      ),
                                                      // Navigate to the ProductDetailScreen when tapped
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetailScreen(
                                                              product: product,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                      } else if (state is SubcategoryError) {
                                        return Center(
                                            child: Text(state.message));
                                      } else {
                                        return const Center(
                                            child: Text('Loading...'));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              );
            }));
  }
}
