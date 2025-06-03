import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AlMostShop"), backgroundColor: primaryColor),
      backgroundColor: bacgroundColor,
      body: Center(
        child: Text(
          "Welcome to AlMostShop Home!",
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
