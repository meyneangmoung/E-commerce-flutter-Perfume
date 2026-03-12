import 'package:ecommerce/screens/users/user_account.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/widget/wishlist_page.dart';
import 'package:ecommerce/screens/card/cart_page.dart';


// --- GLOBAL STATE ---
List<Map<String, dynamic>> globalUserCart = [];
ValueNotifier<List<Map<String, dynamic>>> globalWishlist = ValueNotifier([]);

// --- WISHLIST EXTENSION ---
extension WishlistExtension on ValueNotifier<List<Map<String, dynamic>>> {
  bool containsProduct(Product product) {
    return value.any((item) => item['name'] == product.name);
  }

  void addProduct(Product product) {
    value = [
      ...value,
      {
        'name': product.name,
        'price': product.price,
        'imagePath': product.imagePath,
      },
    ];
  }

  void removeProduct(Product product) {
    value = value.where((item) => item['name'] != product.name).toList();
  }
}

// --- MAIN ---
void main() {
  runApp(const Homepage());
}

void _addItemToGlobalCart(Product product) {
  double priceValue = double.parse(product.price.replaceAll('\$', ''));

  int index = globalUserCart.indexWhere((item) => item['name'] == product.name);

  if (index != -1) {
    globalUserCart[index]['qty']++;
  } else {
    globalUserCart.add({
      'name': product.name,
      'price': priceValue,
      'image': product.imagePath,
      'qty': 1,
    });
  }
}

// --- HOMEPAGE ---
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfume Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- DATA MODEL ---
class Product {
  final String name;
  final String imagePath;
  final String price;

  const Product({
    required this.name,
    required this.imagePath,
    required this.price,
  });
}

const List<Product> trendingProducts = [
  Product(
    name: 'versace',
    imagePath: 'assets/versace.jpg',
    price: '\$125.00',
  ),
  Product(name: 'Scandal',
  imagePath: 'assets/scandal.jpg',
  price: '\$145.00'),

  Product(
    name: 'Si Passione',
    imagePath: 'assets/Si Passione.jpg',
    price: '\$160.00',
  ),

  Product(
    name: 'Burberryher',
    imagePath: 'assets/burberryher.jpg',
    price: '\$115.00',
  ),

  Product(name: 'Prada', 
  imagePath: 'assets/prada.jpg',
  price: '\$130.00'),

  Product(name: 'Chanel',
  imagePath: 'assets/channel.jpg',
  price: '\$125.00'),
];

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _selectedIndex = 0;
  final List<String> categories = ['All', "Men's", "Women's"];
  

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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: trendingProducts.length,
                  itemBuilder: (context, index) =>
                      ProductCard(product: trendingProducts[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistPage()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  

  Widget _buildTopBar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        // Updated this part:
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/user.jpg'), 
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning', style: TextStyle(fontSize: 12, color: Colors.black54)),
            Text('Jennie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
        ),
      ],
    ),
  );
}

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

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
              onTap: () => setState(() => _selectedCategory = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A1A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black12),
                ),
                alignment: Alignment.center,
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
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

// --- PRODUCT CARD ---
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globalWishlist,
      builder: (context, List<Map<String, dynamic>> wishlist, _) {
        bool isLiked = globalWishlist.containsProduct(widget.product);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(product: widget.product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          widget.product.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.product.price,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      if (isLiked) {
                        globalWishlist.removeProduct(widget.product);
                      } else {
                        globalWishlist.addProduct(widget.product);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
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

// --- PRODUCT DETAIL SCREEN ---
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Image.asset(product.imagePath, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Luxurious fragrance with premium notes.",
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _addItemToGlobalCart(product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

