import 'package:flutter/material.dart';
import 'package:ecommerce/global_state.dart';
import 'package:ecommerce/widget/product_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: ValueListenableBuilder(
        valueListenable: globalWishlist,
        builder: (context, List wishlist, _) {
          if (wishlist.isEmpty) {
            return const Center(child: Text("Your wishlist is empty"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              return ProductCard(product: wishlist[index]);
            },
          );
        },
      ),
    );
  }
}