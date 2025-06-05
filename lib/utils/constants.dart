import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecommerce_flutter_app/models/product.dart';

// Theme Colors
const Color primaryColor = Color(0xFFc085ee); // Vibrant green
const Color accentColor = Color(0xFFFF9800); // // Warm orange
const Color bacgroundColor = Color(0xFFF5F5F5); // Light gray
const Color textColor = Color(0xFF333333); // Dark gray

// API URLs
const String baseUrl = 'https://ib.jamalmoallart.com/api/v1';
const String allProductsUrl = '$baseUrl/all/products';
const String categoriesUrl = '$baseUrl/all/categories';

// Fetch Products from API
Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse(allProductsUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception('Error fetching products: $e');
  }
}

// Fetch Categories from API
Future<List<String>> fetchCategories() async {
  try {
    final response = await http.get(Uri.parse(categoriesUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<String>();
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception('Error fetching categories: $e');
  }
}
