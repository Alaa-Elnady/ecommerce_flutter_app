// import 'package:shared_preferences/shared_preferences.dart';

// class StorageService {
//   static const String _isLoggedInKey = 'isLoggedIn';
//   static const String _usernameKey = "username";

//   // To Check if the he is a loggedIn user or not
//   Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }

//   // Set the user as loggedIn user
//   Future<void> setLoggedIn(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isLoggedInKey, value);
//   }

//   Future<String?> getUsername() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_usernameKey);
//   }

//   Future<void> setUsername(String username) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_usernameKey, username);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

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
}
