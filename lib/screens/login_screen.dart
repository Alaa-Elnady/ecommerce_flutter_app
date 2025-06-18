import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_flutter_app/utils/user_model.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/utils/cart_model.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/storage_service.dart';
import 'dart:convert';
import 'dart:math';

class LoginPage extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const LoginPage({super.key, this.arguments});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  final StorageService _storageService = StorageService();
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '[]';
      final List<dynamic> usersList = jsonDecode(usersJson);
      final users = usersList.map((user) => UserModel.fromJson(user)).toList();
      final user = users.firstWhere(
        (user) =>
            user.email == _emailController.text &&
            user.password == _passwordController.text,
        orElse: () => UserModel(
          name: '',
          email: '',
          phone: '',
          address: '',
          password: '',
          token: '',
        ),
      );

      if (user.email.isNotEmpty) {
        String token = user.token.isNotEmpty
            ? user.token
            : _generateRandomToken();

        await prefs.setString('token', token);
        await prefs.setString('userEmail', user.email);

        await _storageService.saveLoginData(email: user.email, token: token);

        if (user.token.isEmpty) {
          final userIndex = users.indexWhere((u) => u.email == user.email);
          if (userIndex != -1) {
            users[userIndex] = UserModel(
              name: user.name,
              email: user.email,
              phone: user.phone,
              address: user.address,
              password: user.password,
              profileImagePath: user.profileImagePath,
              token: token,
            );
            await prefs.setString(
              'users',
              jsonEncode(users.map((u) => u.toJson()).toList()),
            );
          }
        }

        final product = widget.arguments?['product'] as Product?;
        final quantity = widget.arguments?['quantity'] as int? ?? 1;
        if (product != null) {
          try {
            final cart = Provider.of<CartModel>(context, listen: false);
            cart.addProduct(product, quantity: quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added $quantity x ${product.name} to cart'),
                backgroundColor: const Color(0xFF9C27B0),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
            );
          }
        }

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  String _generateRandomToken() {
    final random = Random.secure();
    return List<int>.generate(
      16,
      (_) => random.nextInt(256),
    ).map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/default_profile.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/register',
                        arguments: widget.arguments,
                      );
                    },
                    child: const Text(
                      'Create new account',
                      style: TextStyle(color: Color(0xFFF55348)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
