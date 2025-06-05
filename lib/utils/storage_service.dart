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
