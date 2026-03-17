import 'package:ecommerce/global_state.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/screens/product_detail_screen.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: ManCategory()),
  );
}

class ManCategory extends StatefulWidget {
  const ManCategory({super.key});

  @override
  State<ManCategory> createState() => _ManCategoryState();
}

class _ManCategoryState extends State<ManCategory> {
  final TextEditingController _searchController = TextEditingController();

  //List All Gategory
  final List<Product> allPerfumes = [
    Product(
      title: "Chanel Strong",
      subtitle: "Classic floral fragrance",
      price: "\$120.00",
      image: "assets/chanel strong.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Jean Paul",
      subtitle: "Classic floral fragrance",
      price: "\$135.00",
      image: "assets/jean paul.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Tom Ford",
      subtitle: "Classic floral fragrance",
      price: "\$120.00",
      image: "assets/tom ford.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Versace",
      subtitle: "Classic floral fragrance",
      price: "\$120.00",
      image: "assets/versace.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Stronger With You",
      subtitle: "Classic floral fragrance",
      price: "\$160.00",
      image: "assets/Stronger w u.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Valentino",
      subtitle: "Classic floral fragrance",
      price: "\$160.00",
      image: "assets/valentino.jpg",
      type: "Luxury",
    ),
  ];

  List<Product> filteredPerfumes = [];

  @override
  void initState() {
    super.initState();
    filteredPerfumes = allPerfumes;
  }

  void _runFilter(String enteredKeyword) {
    List<Product> results = [];

    if (enteredKeyword.isEmpty) {
      results = allPerfumes;
    } else {
      results = allPerfumes
          .where(
            (item) =>
                item.title.toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      filteredPerfumes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EE),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "MEN PERFUMES",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "Search your favorite perfume...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 20, 5),
            child: Text(
              "SHOWING ${filteredPerfumes.length} PRODUCTS",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPerfumes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final product = filteredPerfumes[index];

                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: globalWishlist,
      builder: (context, wishlist, _) {
        bool isLiked = globalWishlist.containsProduct(product);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),

            child: Stack(
              children: [
                // ❤️ Heart Icon
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      if (isLiked) {
                        globalWishlist.removeProduct(product);
                      } else {
                        globalWishlist.addProduct(product);
                      }
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                ),

                // Product Type Tag
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      product.type,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Image
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // Subtitle
                      Text(
                        product.subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Price + Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              globalCart.value = [
                                ...globalCart.value,
                                {
                                  'name': product.title,
                                  'price':
                                      double.tryParse(
                                        product.price.replaceAll("\$", ""),
                                      ) ??
                                      0,
                                  'image': product.image,
                                  'qty': 1,
                                  'isSelected': true,
                                },
                              ];

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.title} added to cart',
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
