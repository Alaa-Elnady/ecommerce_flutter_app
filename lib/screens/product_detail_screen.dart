// import 'package:flutter/material.dart';
// import 'package:ecommerce_flutter_app/models/product.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';
// import 'package:ecommerce_flutter_app/utils/storage_service.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     final storageService = await StorageService();
//     bool isLoggedIn = await storageService.isLoggedIn();
//     setState(() {
//       _isLoggedIn = isLoggedIn;
//     });
//   }

//   void _handleAction(BuildContext context) {
//     if (!_isLoggedIn) {
//       Navigator.pushNamed(context, '/login');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Action requires implementation')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//         backgroundColor: primaryColor,
//       ),
//       backgroundColor: bacgroundColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               widget.product.image,
//               height: 300,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 300,
//                 color: bacgroundColor,
//                 child: const Center(
//                   child: Text(
//                     'Image failed to load',
//                     style: TextStyle(color: textColor),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               widget.product.name,
//               style: const TextStyle(
//                 fontFamily: 'Roboto',
//                 fontSize: 24,
//                 color: textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               '\$${widget.product.price.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontFamily: 'Roboto',
//                 fontSize: 20,
//                 color: primaryColor,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               widget.product.description,
//               style: const TextStyle(
//                 fontFamily: 'Roboto',
//                 fontSize: 16,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.favorite_border, color: primaryColor),
//                   onPressed: () => _handleAction(context),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.add_shopping_cart,
//                     color: primaryColor,
//                   ),
//                   onPressed: () => _handleAction(context),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    if (_quantity < 99) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${_quantity} x ${widget.product.name} to cart',
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final discountedPrice = product.price * (1 - product.discount / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(fontFamily: 'Roboto', color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
      ),
      backgroundColor: bacgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
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
              product.name,
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
                if (product.discount > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: textColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${product.discount}% off',
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
                  icon: const Icon(Icons.remove, color: primaryColor),
                  onPressed: _decrementQuantity,
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: primaryColor),
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
              product.description.isNotEmpty
                  ? product.description
                  : 'No description available',
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
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
