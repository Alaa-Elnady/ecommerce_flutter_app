import 'package:ecommerce_flutter_app/models/cart_item.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: json['totalPrice'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
    );
  }
}
