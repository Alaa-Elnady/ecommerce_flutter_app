import 'package:ecommerce_flutter_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
// import 'screens/category_products_screen.dart';
// import 'screens/product_detail_screen.dart';
// import 'screens/cart_screen.dart';
// import 'screens/order_screen.dart';
// import 'screens/profile_screen.dart';
// import 'utils/constants.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green, // Maps to primaryColor (#4CAF50)
          accentColor: accentColor, // Maps to colorScheme.secondary (#FF9800)
        ).copyWith(secondary: accentColor, background: bacgroundColor),
        scaffoldBackgroundColor: bacgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashScreen(),
        // "/register": (context) => RegisterScreen(),
        // "/login": (context) => LoginScreen(),
        "/": (context) => HomeScreen(),
        // "/products": (context) => ProductDetailsScreen(),
        // "/cart": (context) => CartScreen(),
        // "/orders": (context) => OrderScreen(),
        // "/profile": (context) => ProfileScreen(),
        // "/category": (context) => CategoryProductsScreen(),
      },
    );
  }
}
