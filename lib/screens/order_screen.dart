import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:ecommerce_flutter_app/utils/order_model.dart';
// import 'package:ecommerce_flutter_app/models/cart_item.dart';
import 'package:ecommerce_flutter_app/screens/app_drawer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<OrderModel>> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('orders') ?? '[]';
      final List<dynamic> ordersList = jsonDecode(ordersJson);
      return ordersList.map((order) => OrderModel.fromJson(order)).toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
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
        child: FutureBuilder<List<OrderModel>>(
          future: _loadOrders(),
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
                  'No orders found',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              );
            }
            final orders = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy – HH:mm',
                              ).format(order.orderDate),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Order Items
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 50,
                                              height: 50,
                                              color: bacgroundColor,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: textColor,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${(item.price * item.quantity * (1 - item.discount / 100)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 16),
                        // Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${order.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
