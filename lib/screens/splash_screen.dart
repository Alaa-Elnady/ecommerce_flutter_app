import "package:flutter/material.dart";
import 'dart:async';
import '../utils/constants.dart';
import '../utils/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    // Check login status and navigate
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final storageService = StorageService();
    bool isLoggedIn = await storageService.isLoggedIn();
    print("LoggedIn User : $isLoggedIn");

    // Wait for  seconds to show splash screen
    await Future.delayed(Duration(seconds: 3));

    // Navigate to HomeScreen regardless of ligin status
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image from assets
          Image.asset(
            '../../assets/images/splash_bg.jfif',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: bacgroundColor),
          ),

          // Background Image from network
          // Image.network(
          //   "https://images.unsplash.com/photo-1511556820780-d912e42b4980",
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) =>
          //       Container(color: bacgroundColor),
          //   loadingBuilder: (context, child, loadingProgress) {
          //     if (loadingProgress == null) return child;
          //     return Container(
          //       color: bacgroundColor,
          //       child: Center(
          //         child: CircularProgressIndicator(
          //           valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          //         ),
          //       ),
          //     );
          //   },
          // ),

          // Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.4)),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "AlMostShop",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Welcome to Your Shopping World!",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 32),

                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
