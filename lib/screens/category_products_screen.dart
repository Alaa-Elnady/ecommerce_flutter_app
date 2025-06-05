import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/cart_model.dart';
import 'package:ecommerce_flutter_app/utils/storage_service.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:ecommerce_flutter_app/screens/app_drawer.dart';
import 'package:ecommerce_flutter_app/screens/search_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Future<List<Product>> _productsFuture;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final storageService = StorageService();
    bool isAuthenticated = await storageService.isLoggedIn();
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  void _handleAction(
    BuildContext context, {
    required String action,
    Product? product,
  }) async {
    if (!_isAuthenticated) {
      Navigator.pushNamed(
        context,
        '/login',
        arguments: action == 'cart' ? {'product': product} : null,
      );
      return;
    }

    if (action == 'cart' && product != null) {
      try {
        final cart = Provider.of<CartModel>(context, listen: false);
        cart.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${product.name} added to cart',
              style: const TextStyle(fontFamily: 'Roboto'),
            ),
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
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
        title: Text(
          widget.category[0].toUpperCase() + widget.category.substring(1),
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/circle design.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: FutureBuilder<List<Product>>(
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
                  'No products found',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              );
            }
            final products = snapshot.data!
                .where(
                  (product) =>
                      (product.category ?? '').toLowerCase() ==
                      widget.category.toLowerCase(),
                )
                .toList();
            if (products.isEmpty) {
              return const Center(
                child: Text(
                  'No products in this category',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final discountedPrice =
                    product.price * (1 - (product.discount ?? 0) / 100);
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: product,
                    );
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
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: bacgroundColor,
                                    child: const Center(
                                      child: Text(
                                        'Image failed',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: textColor,
                                        ),
                                      ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${discountedPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (product.discount != null &&
                                      product.discount! > 0)
                                    Text(
                                      '${product.discount}% off',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: accentColor,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () => _handleAction(
                                      context,
                                      action: 'favorite',
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () => _handleAction(
                                      context,
                                      action: 'cart',
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
        ),
      ),
    );
  }
}
