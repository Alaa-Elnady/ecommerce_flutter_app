import 'package:flutter/material.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:ecommerce_flutter_app/utils/storage_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final storageService = await StorageService();
    bool isLoggedIn = await storageService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  void _handleAction(BuildContext context) {
    if (!_isLoggedIn) {
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Action requires implementation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: primaryColor,
      ),
      backgroundColor: bacgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: bacgroundColor,
                child: const Center(
                  child: Text(
                    'Image failed to load',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.description,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: primaryColor),
                  onPressed: () => _handleAction(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: primaryColor,
                  ),
                  onPressed: () => _handleAction(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
