import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.pink[100],
      ),
      body: BlocBuilder<CartCubit, CartAndFavoritesState>(
        builder: (context, state) {
          final favoriteProducts = state.favoriteItems;

          if (favoriteProducts.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              final name = product.name;
              final price = product.price;
              final imageUrl = product.imageLink;

              // Check if the product is already in favorites
              final isFavorite = context.read<CartCubit>().isFavorite(product);

              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(imageUrl,
                        width: mediaQuery.size.width * 0.2,
                        height: mediaQuery.size.height * 0.3,
                        fit: BoxFit.cover)
                    : const Icon(Icons.image),
                title: Text(name),
                subtitle: Text('\$$price'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isFavorite
                        ? Colors.pink[200]
                        : Colors.grey, // Change color based on favorite status
                  ),
                  onPressed: () {
                    context.read<CartCubit>().toggleFavorite(product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
