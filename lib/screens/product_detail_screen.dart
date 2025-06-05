import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/cart_model.dart';
import 'package:ecommerce_flutter_app/utils/storage_service.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:ecommerce_flutter_app/screens/app_drawer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    if (_quantity < (widget.product.stock ?? 99)) {
      setState(() {
        _quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot exceed available stock')),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart(BuildContext context) async {
    final storageService = StorageService();
    final isLoggedIn = await storageService.isLoggedIn();

    if (isLoggedIn) {
      try {
        final cart = Provider.of<CartModel>(context, listen: false);
        cart.addProduct(widget.product, quantity: _quantity);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added $_quantity x ${widget.product.name} to cart',
              style: const TextStyle(fontFamily: 'Roboto'),
            ),
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _quantity = 1; // Reset quantity after adding
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      Navigator.pushNamed(
        context,
        '/login',
        arguments: {'product': widget.product, 'quantity': _quantity},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        widget.product.price * (1 - (widget.product.discount ?? 0) / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      width: double.infinity,
                      color: bacgroundColor,
                      child: const Center(
                        child: Text(
                          'Image failed to load',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Product Name
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Price and Discount
              Row(
                children: [
                  Text(
                    '\$${discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.product.discount != null &&
                      widget.product.discount! > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: textColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.product.discount}% off',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: accentColor,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Quantity Selector
              Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: primaryColor),
                    onPressed: _decrementQuantity,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: primaryColor),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.description ?? 'No description available',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _addToCart(context),
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
