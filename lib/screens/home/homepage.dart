import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/widget/product_card.dart';
import 'package:ecommerce/screens/category/mencategory.dart';
import 'package:ecommerce/screens/category/womencategory.dart';
import 'package:ecommerce/screens/users/user_account.dart';
import 'package:ecommerce/widget/wishlist_page.dart';
import 'package:ecommerce/screens/card/cart_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedCategory = 0;
  int _selectedIndex = 0;

  TextEditingController searchController = TextEditingController();

  /// PRODUCT LIST
  final List<Product> trendingProducts = [
    Product(
      title: "Versace",
      subtitle: "Luxury fragrance",
      price: "\$125.00",
      image: "assets/versace.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Scandal",
      subtitle: "Elegant scent",
      price: "\$145.00",
      image: "assets/scandal.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Si Passione",
      subtitle: "Fruity and floral",
      price: "\$160.00",
      image: "assets/Si Passione.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Burberry Her",
      subtitle: "Classic elegance",
      price: "\$115.00",
      image: "assets/burberryher.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Prada",
      subtitle: "Fresh and modern",
      price: "\$130.00",
      image: "assets/prada.jpg",
      type: "Luxury",
    ),
    Product(
      title: "Chanel",
      subtitle: "Timeless classic",
      price: "\$125.00",
      image: "assets/channel.jpg",
      type: "Luxury",
    ),
  ];

  /// FILTERED PRODUCTS
  List<Product> filteredProducts = [];

  final List<String> categories = ["All", "Men's", "Women's"];

  @override
  void initState() {
    super.initState();
    filteredProducts = trendingProducts;
  }

  /// SEARCH FUNCTION
  void searchProduct(String query) {
    final results = trendingProducts.where((product) {
      final title = product.title.toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input);
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            _buildTopBar(),

            _buildSearchBar(),

            _buildCategoryBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {

          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WishlistPage(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserAccountScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// TOP BAR
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/user.jpg"),
          ),
          const SizedBox(width: 10),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Jennie",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        child: TextField(
          controller: searchController,
          onChanged: searchProduct,
          decoration: const InputDecoration(
            hintText: "Search product...",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// CATEGORY BAR
  Widget _buildCategoryBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: SizedBox(
        height: 45,

        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,

          itemBuilder: (context, index) {

            bool isSelected = _selectedCategory == index;

            return GestureDetector(
              onTap: () {

                setState(() {
                  _selectedCategory = index;
                });

                if (categories[index] == "Men's") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManCategory(),
                    ),
                  );
                }

                if (categories[index] == "Women's") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Womencategory(),
                    ),
                  );
                }
              },

              child: Container(
                margin: const EdgeInsets.only(right: 12),

                padding:
                    const EdgeInsets.symmetric(horizontal: 25),

                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A1A2E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black12),
                ),

                alignment: Alignment.center,

                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
}