import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ecommerce_flutter_app/models/cart_item.dart';
import 'package:ecommerce_flutter_app/utils/order_model.dart';
import 'package:ecommerce_flutter_app/models/product.dart';

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart') ?? '[]';
      final List<dynamic> cartList = jsonDecode(cartJson);
      _items = cartList.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading cart: $e');
      _items = [];
      notifyListeners();
    }
  }

  Future<void> saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart', cartJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  void addProduct(Product product, {int quantity = 1}) {
    if (quantity <= 0) return;

    if (product.stock != null && product.stock! < quantity) {
      throw Exception('Insufficient stock for ${product.name}');
    }

    final existingItemIndex = _items.indexWhere(
      (item) => item.productId == product.id.toString(),
    );
    if (existingItemIndex >= 0) {
      final newQuantity = _items[existingItemIndex].quantity + quantity;
      if (product.stock != null && newQuantity > product.stock!) {
        throw Exception('Cannot add more ${product.name} than available stock');
      }
      _items[existingItemIndex] = _items[existingItemIndex].copyWith(
        quantity: newQuantity,
      );
    } else {
      _items.add(
        CartItem(
          productId: product.id.toString(),
          name: product.name,
          price: product.price,
          image: product.image,
          quantity: quantity,
          discount: product.discount ?? 0.0,
        ),
      );
    }
    saveToPrefs();
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex >= 0) {
      _items[itemIndex] = _items[itemIndex].copyWith(
        quantity: _items[itemIndex].quantity + 1,
      );
      saveToPrefs();
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex >= 0) {
      final newQuantity = _items[itemIndex].quantity - 1;
      if (newQuantity <= 0) {
        _items.removeAt(itemIndex);
      } else {
        _items[itemIndex] = _items[itemIndex].copyWith(quantity: newQuantity);
      }
      saveToPrefs();
      notifyListeners();
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex >= 0) {
      _items[itemIndex] = _items[itemIndex].copyWith(quantity: quantity);
      saveToPrefs();
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    saveToPrefs();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (total, item) {
      final discountedPrice = item.price * (1 - item.discount / 100);
      return total + discountedPrice * item.quantity;
    });
  }

  Future<void> clearCart(BuildContext context) async {
    try {
      if (_items.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: _items,
        totalPrice: totalPrice,
        orderDate: DateTime.now(),
      );
      final ordersJson = prefs.getString('orders') ?? '[]';
      final List<dynamic> ordersList = jsonDecode(ordersJson);
      ordersList.add(order.toJson());
      await prefs.setString('orders', jsonEncode(ordersList));

      _items.clear();
      await saveToPrefs();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Failed to process order');
    }
  }

  void clear() {
    _items.clear();
    saveToPrefs();
    notifyListeners();
  }
}
