import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // Check user logging
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Get username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail');
    if (email == null) return null;
    final usersJson = prefs.getString('users') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);
    final user = usersList.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {'name': 'User'},
    );
    return user['name'] as String?;
  }

  // Save user login data
  Future<void> saveLoginData({
    required String email,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('currentUserEmail', email);
    await prefs.setString('userToken', token);
  }

  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Clear user login data
  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentUserEmail');
    await prefs.remove('userToken');
  }
}
