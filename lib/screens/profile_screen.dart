import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _imageUrlController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _imageUrlController = TextEditingController();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    print("token is: '$token'");

    if (token.isEmpty) {
      setState(() {
        _nameController.text = "Not logged in";
        _emailController.text = "Login required";
      });
      return;
    }

    final url = Uri.parse('https://ib.jamalmoallart.com/api/v2/profile');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'] ?? "Unknown";
          _emailController.text = data['email'] ?? "No email";
          _imageUrlController.text =
              data['profile_image'] ?? "https://via.placeholder.com/150";
        });
        await _saveToPreferences();
      } else {
        setState(() {
          _nameController.text = "Error loading data";
          _emailController.text = "Please try again";
        });
      }
    } catch (e) {
      setState(() {
        _nameController.text = "Error";
        _emailController.text = "Check your connection";
      });
    }
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userEmail', _emailController.text);
    await prefs.setString('profileImageUrl', _imageUrlController.text);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing) {
      _saveToPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: textColor),
              onPressed: _toggleEditMode,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save, color: textColor),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      backgroundColor: bacgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_imageUrlController.text),
            ),
            const SizedBox(height: 20),
            _isEditing
                ? TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  )
                : Text(
                    _nameController.text,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
            const SizedBox(height: 10),
            _isEditing
                ? TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  )
                : Text(
                    _emailController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
            const SizedBox(height: 10),
            _isEditing
                ? TextField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(accentColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Logged out")));
                Navigator.pop(context);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
