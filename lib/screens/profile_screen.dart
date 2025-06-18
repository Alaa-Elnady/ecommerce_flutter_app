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

    print("the token is: $token");

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

      // final request = http.Request('GET', url);
      // request.headers.addAll({
      //   "Accept": "application/json",
      //   "Content-Type": "application/json",
      // });

      // request.body = jsonDecode({"token": token});

      // final response = await request.send();

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
      backgroundColor: bacgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile', style: TextStyle(color: textColor)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: textColor),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor.withOpacity(0.3),
                  backgroundImage: NetworkImage(_imageUrlController.text),
                ),
                const SizedBox(height: 20),
                _isEditing
                    ? _buildEditableField(
                        controller: _nameController,
                        label: "Name",
                      )
                    : _buildTextLabel(_nameController.text, 22, true),
                const SizedBox(height: 12),
                _isEditing
                    ? _buildEditableField(
                        controller: _emailController,
                        label: "Email",
                      )
                    : _buildTextLabel(
                        _emailController.text,
                        16,
                        false,
                        opacity: 0.7,
                      ),
                const SizedBox(height: 12),
                _isEditing
                    ? _buildEditableField(
                        controller: _imageUrlController,
                        label: "Image URL",
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("Logged out")));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildTextLabel(
    String text,
    double fontSize,
    bool bold, {
    double opacity = 1,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        color: textColor.withOpacity(opacity),
      ),
    );
  }
}
