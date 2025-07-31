import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height*0.03,horizontal: mediaQuery.size.width*0.01),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CartCubit, CartAndFavoritesState>(
                builder: (context, cartState) {
                  // Access the cartItems list
                  final cartItems = cartState.cartItems;

                  if (cartItems.isEmpty) {
                    return const Center(child: Text('Your cart is empty.'));
                  }

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      final name = product.name;
                      final price = product.price;
                      final imageUrl = product.imageLink;

                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl,  width: mediaQuery.size.width*0.2, height: mediaQuery.size.height*0.3, fit: BoxFit.cover)
                            : const Icon(Icons.image),
                        title: Text(name),
                        subtitle: Text('\$$price'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.pink[200]),
                          onPressed: () {
                            context.read<CartCubit>().toggleCartItem(product);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<CartCubit, CartAndFavoritesState>(
              builder: (context, cartState) {
                final total = context.read<CartCubit>().getTotalPrice();
                return Padding(
                 padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height*0.01),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height*0.01,
                    horizontal: mediaQuery.size.width*0.02),
                    decoration: BoxDecoration(color: Colors.pink[100],borderRadius: 
                    BorderRadius.circular(20)),
                    child: Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
