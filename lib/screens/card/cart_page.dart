import 'package:flutter/material.dart';
import 'package:ecommerce/screens/checkout/checkout_page.dart';
import '../../global_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // 1. Calculate subtotal for selected items
  double get subtotal => globalCart.value
      .where((item) => item['isSelected'] == true)
      .fold(0, (sum, item) => sum + (item['price'] * item['qty']));

  // 2. Remove item from cart
  void _removeItem(int index) {
    globalCart.value = List.from(globalCart.value)..removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: globalCart,
        builder: (context, cartItems, _) {
          if (cartItems.isEmpty) return _buildEmptyState();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _removeItem(index),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: _buildCartItem(item, index),
                    );
                  },
                ),
              ),
              _buildCheckoutSection(),
            ],
          );
        },
      ),
    );
  }

  // Individual cart item widget
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Checkbox(
              activeColor: const Color(0xFF1A1A2E),
              value: item['isSelected'],
              onChanged: (bool? value) {
                setState(() {
                  item['isSelected'] = value;
                });
              },
            ),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(item['image'], fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("\$${item['price'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _removeItem(index),
                ),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (item['qty'] > 1) setState(() => item['qty']--);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("${item['qty']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyButton(Icons.add, () {
                      setState(() => item['qty']++);
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quantity button
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  // Checkout section at the bottom
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payable", style: TextStyle(fontSize: 18, color: Colors.black54)),
              Text(
                "\$${subtotal.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (subtotal > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select at least one item to checkout")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Checkout Now", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // Empty cart state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Your cart is empty!", style: TextStyle(color: Colors.grey, fontSize: 18)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go Shopping", style: TextStyle(color: Color(0xFF1A1A2E))),
          )
        ],
      ),
    );
  }
}