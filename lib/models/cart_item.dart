import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

class CartItem {
  final String productId;
  int quantity;

  CartItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(productId: json['productId'], quantity: json['quantity']);
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];
  Map<String, Product> _products = {};

  List<CartItem> get items => _items;

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> jsonData = jsonDecode(cartData);
      _items = jsonData.map((item) => CartItem.fromJson(item)).toList();
      // Fetch products for cart items
      await _fetchProductsForCart();
      notifyListeners();
    }
  }

  Future<void> _fetchProductsForCart() async {
    try {
      final products = await fetchProducts();
      _products = {for (var product in products) product.id: product};
      // Remove cart items with missing products
      _items.removeWhere((item) => _products[item.productId] == null);
      await saveToPrefs();
    } catch (e) {
      print('Error fetching products for cart: $e');
    }
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cart', cartData);
  }

  Product? getProduct(String productId) {
    return _products[productId];
  }

  void addProduct(Product product, int quantity) {
    if (quantity <= 0) return;
    _products[product.id] = product;
    final existingItemIndex = _items.indexWhere(
      (item) => item.productId == product.id,
    );
    if (existingItemIndex >= 0) {
      _items[existingItemIndex] = CartItem(
        productId: product.id,
        quantity: _items[existingItemIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(productId: product.id, quantity: quantity));
    }
    saveToPrefs();
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    saveToPrefs();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex >= 0) {
      _items[itemIndex] = CartItem(productId: productId, quantity: quantity);
      saveToPrefs();
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _items.fold(0.0, (total, item) {
      final product = getProduct(item.productId);
      if (product == null) return total;
      final discountedPrice = product.price * (1 - product.discount / 100);
      return total + discountedPrice * item.quantity;
    });
  }

  void clearCart() {
    _items.clear();
    saveToPrefs();
    notifyListeners();
  }
}
