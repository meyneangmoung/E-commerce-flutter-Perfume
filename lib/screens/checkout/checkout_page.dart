import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getPaypalItems() {
    return widget.cartItems.map((item) {
      return {
        "name": item['name'],
        "quantity": item['qty'].toString(),
        "price": (item['price'] as num).toStringAsFixed(2),
        "currency": "USD",
      };
    }).toList();
  }

  void payWithPaypal() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: "ATJ1prgQgaGFyHJKgCQxnthidUHZYNaC6JhlXkN2ek-o-JmEwd9UUwQiEVcctKC-W2oVAAj6XdXfZbxf",
          secretKey: "ELwN2iMHiM19VTo1NCJrWi9leH8tkUdy4cY0xFF2PDBVFUNLrrRKxVf_4tztauAh-RsxW4D0E0aXJO6v",
          transactions: [
            {
              "amount": {
                "total": widget.totalAmount.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": widget.totalAmount.toStringAsFixed(2),
                  "shipping": "0",
                  "shipping_discount": 0
                }
              },
              "description": "GenZ Shop Checkout Payment",
              "item_list": {
                "items": getPaypalItems(),
              }
            }
          ],
          note: "Thank you for your order!",
          onSuccess: (Map params) async {
            debugPrint("PayPal Success: $params");

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Payment successful"),
                  backgroundColor: Colors.green,
                ),
              );
              // Pop the PayPal view and return to home or clear cart
              Navigator.pop(context); 
            }
          },
          onError: (error) {
            debugPrint("PayPal Error: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Payment failed: $error"),
                backgroundColor: Colors.red,
              ),
            );
          },
          onCancel: () {
            debugPrint("PayPal Cancelled");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment cancelled"),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validationMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildOrderSummary() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item['name']} x${item['qty']}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      "\$${((item['price'] as num) * (item['qty'] as num)).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${widget.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                label: "Full Name",
                controller: fullNameController,
                validationMessage: "Please enter full name",
              ),
              buildTextField(
                label: "Phone Number",
                controller: phoneController,
                validationMessage: "Please enter phone number",
                keyboardType: TextInputType.phone,
              ),
              buildTextField(
                label: "Address",
                controller: addressController,
                validationMessage: "Please enter address",
                maxLines: 2,
              ),
              buildTextField(
                label: "City",
                controller: cityController,
                validationMessage: "Please enter city",
              ),
              const SizedBox(height: 10),
              buildOrderSummary(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: payWithPaypal,
                  child: Text(
                    "Pay with PayPal (\$${widget.totalAmount.toStringAsFixed(2)})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}