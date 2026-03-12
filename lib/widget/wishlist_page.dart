import 'package:flutter/material.dart';
import 'package:ecommerce/screens/home/homepage.dart';




class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: ValueListenableBuilder(
        valueListenable: globalWishlist,
        builder: (context, List<Map<String, dynamic>> wishlist, _) {
          if (wishlist.isEmpty) {
            return const Center(
              child: Text(
                "Your wishlist is empty.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: wishlist.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = wishlist[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      item['imagePath'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['price'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // Remove from wishlist
                        final product = Product(
                          name: item['name'],
                          imagePath: item['imagePath'],
                          price: item['price'],
                        );
                        globalWishlist.removeProduct(product);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}