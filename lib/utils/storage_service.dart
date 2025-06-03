import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isLoggedInKey = 'isLoggedIn';

  // To Check if the he is a loggedIn user or not
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Set the user as loggedIn user
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }
}
