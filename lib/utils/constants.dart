import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

// Theme Colors
const Color primaryColor = Color(0xFF4CAF50); // Vibrant green
const Color accentColor = Color(0xFFFF9800); // // Warm orange
const Color bacgroundColor = Color(0xFFF5F5F5); // Light gray
const Color textColor = Color(0xFF333333); // Dark gray

// API URLs for (products & categories)
const String ProductsApiUrl =
    "https://ib.jamalmoallart.com/api/v1/all/products";
const String CategoriesApiUrl =
    "https://ib.jamalmoallart.com/api/v1/all/categories";

// Fetch Products from API
Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse(ProductsApiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching products: $e");
    return []; // Return empty list in error
  }
}

// Fetch Categories from API
Future<List<String>> fetchCategories() async {
  try {
    final response = await http.get(Uri.parse(CategoriesApiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<String>();
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching categories: $e");
    return [
      "Computers",
      "Mobiles",
      "Audio",
      "Accessories",
      "Tablets",
      "TVs",
      "Cameras",
      "Wearables",
    ];
  }
}
