import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/screens/search_screen.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:ecommerce_flutter_app/utils/storage_service.dart';
import 'package:ecommerce_flutter_app/utils/cart_model.dart';
import 'package:ecommerce_flutter_app/screens/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<List<String>> _categoriesFuture;
  bool _isLoggedIn = false;
  String? _username;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    _categoriesFuture = fetchCategories();
    _checkLoginStatus();
    _startAutoScroll();
    // Load cart data
    Provider.of<CartModel>(context, listen: false).loadFromPrefs();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage % 5,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final storageService = StorageService();
    bool isLoggedIn = await storageService.isLoggedIn();
    String? username = await storageService.getUsername();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _username = username;
    });
  }

  void _handleAction(
    BuildContext context, {
    required String action,
    Product? product,
  }) async {
    final storageService = StorageService();
    bool isLoggedIn = await storageService.isLoggedIn();

    if (action == 'add_to_cart' && product != null) {
      if (isLoggedIn) {
        try {
          final cart = Provider.of<CartModel>(context, listen: false);
          cart.addProduct(product, quantity: 1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to cart')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } else {
        Navigator.pushNamed(context, '/login', arguments: {'product': product});
      }
    } else if (action == 'favorite') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorite feature not implemented'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AlMostShop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartModel>(
                  builder: (context, cart, child) => cart.items.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.items.length}',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: bacgroundColor,
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/circle design.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoggedIn
                    ? Text(
                        "Welcome, ${_username ?? "User"}!",
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/register"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ),

              // Product Slider
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Failed to load slider',
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }
                  final products = snapshot.data!.take(5).toList();
                  return SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product',
                              arguments: product,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: bacgroundColor,
                                      child: const Center(
                                        child: Text(
                                          'Image failed to load',
                                          style: TextStyle(color: textColor),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Featured Products
              _sectionTitle('Featured Products'),
              _buildProductGrid(_productsFuture, takeLast: false),

              // Categories
              _sectionTitle('Categories'),
              _buildCategoriesList(),

              // New Arrivals
              _sectionTitle('New Arrivals'),
              _buildProductGrid(_productsFuture, takeLast: true),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductGrid(
    Future<List<Product>> future, {
    bool takeLast = false,
  }) {
    return FutureBuilder<List<Product>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No products found',
              style: TextStyle(color: textColor),
            ),
          );
        }
        final products = takeLast
            ? snapshot.data!.reversed.take(4).toList()
            : snapshot.data!.take(4).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/product', arguments: product);
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: bacgroundColor,
                          child: const Center(
                            child: Text(
                              'Image failed',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: primaryColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  color: primaryColor,
                                ),
                                onPressed: () =>
                                    _handleAction(context, action: 'favorite'),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: primaryColor,
                                ),
                                onPressed: () => _handleAction(
                                  context,
                                  action: 'add_to_cart',
                                  product: product,
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
      },
    );
  }

  Widget _buildCategoriesList() {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No categories available',
              style: TextStyle(color: textColor),
            ),
          );
        }
        final categories = snapshot.data!;
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(
                    category[0].toUpperCase() + category.substring(1),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: textColor,
                    ),
                  ),
                  backgroundColor: primaryColor.withOpacity(0.1),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/category',
                      arguments: category,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
