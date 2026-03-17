import 'package:flutter/material.dart';
import 'models/product_model.dart';

/// GLOBAL STATE
List<Product> globalUserCart = [];
// ValueNotifier<List<Product>> globalCart = ValueNotifier([]);
ValueNotifier<List<Product>> globalWishlist = ValueNotifier([]);
ValueNotifier<List<Map<String, dynamic>>> globalCart = ValueNotifier([]);

/// WISHLIST EXTENSION
extension WishlistExtension on ValueNotifier<List<Product>> {
  bool containsProduct(Product product) {
    return value.any((item) => item.title == product.title);
  }

  void addProduct(Product product) {
    value = [...value, product];
  }

  void removeProduct(Product product) {
    value = value.where((item) => item.title != product.title).toList();
  }
}

/// ADD TO CART FUNCTION
void addItemToGlobalCart(Product product) {
  globalUserCart.add(product);
}