import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/models/cart_item.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontFamily: 'Roboto', color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      backgroundColor: bacgroundColor,
      body: cartModel.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: textColor,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartModel.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartModel.items[index];
                      final product = cartModel.getProduct(cartItem.productId);
                      if (product == null) return const SizedBox.shrink();
                      return _buildCartItem(
                        context,
                        cartModel,
                        cartItem,
                        product,
                      );
                    },
                  ),
                ),
                _buildTotalAndOrder(context, cartModel),
              ],
            ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartModel cartModel,
    CartItem cartItem,
    Product product,
  ) {
    final discountedPrice = product.price * (1 - product.discount / 100);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: bacgroundColor,
                  child: const Center(
                    child: Text(
                      'Image failed',
                      style: TextStyle(fontFamily: 'Roboto', color: textColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                  if (product.discount > 0)
                    Text(
                      '${product.discount}% off',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: accentColor,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Quantity Controls
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: primaryColor),
                        onPressed: () {
                          cartModel.updateQuantity(
                            cartItem.productId,
                            cartItem.quantity - 1,
                          );
                        },
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: primaryColor),
                        onPressed: () {
                          cartModel.updateQuantity(
                            cartItem.productId,
                            cartItem.quantity + 1,
                          );
                        },
                      ),
                      const Spacer(),
                      // Remove Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cartModel.removeProduct(cartItem.productId);
                        },
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
  }

  Widget _buildTotalAndOrder(BuildContext context, CartModel cartModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${cartModel.getTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                cartModel.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed successfully',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    backgroundColor: primaryColor,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Place Order',
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
    );
  }
}
