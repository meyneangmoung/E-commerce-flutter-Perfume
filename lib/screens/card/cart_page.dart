import 'package:flutter/material.dart';
import 'package:ecommerce/screens/checkout/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
   //--SIMPLE CARD
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Gucci Flora',
     'price': 120.00, 
     'image': 'assets/gucci.jpg',
      'qty': 1,
     'isSelected': true},

    {'name': 'Scandal',
     'price': 145.00, 
     'image': 'assets/scandal.jpg', 
     'qty': 1, 
     'isSelected': false},

    {'name': 'Si Passione', 
    'price': 145.00, 
    'image': 'assets/Si Passione.jpg',
     'qty': 1, 
     'isSelected': false},

    {'name': 'Burberry Her', 
    'price': 145.00, 
    'image': 'assets/burberryher.jpg',
     'qty': 1, 'isSelected': false},

    {'name': 'Prada',
     'price': 130.00, 
     'image': 'assets/prada.jpg', 
     'qty': 1,
      'isSelected': false},
      
    {'name': 'Chanel',
     'price': 125.00, 
     'image': 'assets/channel.jpg', 
     'qty': 1, 
     'isSelected': false},
     
     //--Man card
      {'name': 'chanel strong',
     'price': 125.00, 
     'image': 'assets/chanel strong.jpg',
      'qty': 1,
     'isSelected': true},

    {'name': 'jean paul',
     'price': 145.00, 
     'image': 'assets/jean paul.jpg', 
     'qty': 1, 
     'isSelected': false},

    {'name': 'strong with u', 
    'price': 145.00, 
    'image': 'assets/stronger with u.jpg',
     'qty': 1, 
     'isSelected': false},

    {'name': 'savage dior', 
    'price': 145.00, 
    'image': 'assets/savage dior.jpg',
     'qty': 1, 'isSelected': false},

    {'name': 'tom ford',
     'price': 130.00, 
     'image': 'assets/tom ford.jpg', 
     'qty': 1,
      'isSelected': false},
      
    {'name': 'versace',
     'price': 125.00, 
     'image': 'assets/versace.jpg', 
     'qty': 1, 
     'isSelected': false},
  ];

  // 2. LOGIC: Calculate total only for selected items
  double get subtotal => cartItems
      .where((item) => item['isSelected'] == true)
      .fold(0, (sum, item) => sum + (item['price'] * item['qty']));

  // 3. DELETE LOGIC: Removes item and refreshes the UI/Total
  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // BACK TO HOME LOGIC
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () {
            // This takes the user back to the previous screen (Home)
            Navigator.pop(context);
          },
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      // SWIPE TO DELETE
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _removeItem(index),
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
            ),
    );
  }

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
            // CHECKBOX: Toggles if the item is included in Total Payable
            Checkbox(
              activeColor: const Color(0xFF1A1A2E),
              value: item['isSelected'],
              onChanged: (bool? value) {
                setState(() {
                  item['isSelected'] = value;
                });
              },
            ),
            // PRODUCT IMAGE
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
            // NAME & PRICE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("\$${item['price'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            // DELETE BUTTON & QUANTITY
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _removeItem(index), // CLICK TO DELETE
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
              // --- NAVIGATION LOGIC ---
              if (subtotal > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(), // Use your actual class name here
                  ),
                );
              } else {
                // Optional: Show a message if no items are selected
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Your cart is empty!", style: TextStyle(color: Colors.grey, fontSize: 18)),
          TextButton(
            onPressed: () => Navigator.pop(context), // BACK TO HOME
            child: const Text("Go Shopping", 
            style: TextStyle(color: Color(0xFF1A1A2E))
            ),
          )
        ],
      ),
    );
  }
}