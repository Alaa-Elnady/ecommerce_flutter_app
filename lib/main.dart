import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/screens/splash_screen.dart';
import 'package:ecommerce_flutter_app/screens/login_screen.dart';
import 'package:ecommerce_flutter_app/screens/register_screen.dart';
import 'package:ecommerce_flutter_app/screens/home_screen.dart';
// import 'package:ecommerce_flutter_app/screens/order_screen.dart';
import 'package:ecommerce_flutter_app/screens/product_detail_screen.dart';
import 'package:ecommerce_flutter_app/screens/cart_screen.dart';
import 'package:ecommerce_flutter_app/screens/category_products_screen.dart';
// import 'package:ecommerce_flutter_app/models/cart_item.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/utils/cart_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        primaryColor: const Color(0xFF9C27B0),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFF55348),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeScreen(),
        // '/orders': (context) => const OrdersPage(),
        '/cart': (context) => const CartScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final product = settings.arguments as Product?;
          if (product != null) {
            return MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            );
          }
        } else if (settings.name == '/category') {
          final category = settings.arguments as String?;
          if (category != null) {
            return MaterialPageRoute(
              builder: (context) => CategoryProductsScreen(category: category),
            );
          }
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Page Not Found'),
            backgroundColor: const Color(0xFF9C27B0),
          ),
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      ),
    );
  }
}
