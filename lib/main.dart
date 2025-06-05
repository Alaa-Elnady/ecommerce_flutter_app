// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// // import 'screens/register_screen.dart';
// // import 'screens/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/category_products_screen.dart';
// import 'screens/product_detail_screen.dart';
// // import 'screens/cart_screen.dart';
// // import 'screens/order_screen.dart';
// // import 'screens/profile_screen.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';
// import 'package:ecommerce_flutter_app/models/product.dart';

// void main() {
//   runApp(const ECommerceApp());
// }

// class ECommerceApp extends StatelessWidget {
//   const ECommerceApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'E-Commerce App',
//       theme: ThemeData(
//         primaryColor: primaryColor,
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: Colors.green, // Maps to primaryColor (#4CAF50)
//           accentColor: accentColor, // Maps to colorScheme.secondary (#FF9800)
//         ).copyWith(secondary: accentColor, background: bacgroundColor),
//         scaffoldBackgroundColor: bacgroundColor,
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//           bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//         ),
//         buttonTheme: ButtonThemeData(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//       initialRoute: "/splash",
//       routes: {
//         "/splash": (context) => SplashScreen(),
//         // "/register": (context) => RegisterScreen(),
//         // "/login": (context) => LoginScreen(),
//         "/": (context) => HomeScreen(),
//         '/product': (context) => ProductDetailScreen(
//           product: ModalRoute.of(context)!.settings.arguments as Product,
//         ),
//         // "/cart": (context) => CartScreen(),
//         // "/orders": (context) => OrderScreen(),
//         // "/profile": (context) => ProfileScreen(),
//         '/category': (context) => CategoryProductsScreen(
//           category: ModalRoute.of(context)!.settings.arguments as String,
//         ),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter_app/models/product.dart';
import 'package:ecommerce_flutter_app/models/cart_item.dart';
import 'package:ecommerce_flutter_app/screens/splash_screen.dart';
import 'package:ecommerce_flutter_app/screens/home_screen.dart';
import 'package:ecommerce_flutter_app/screens/category_products_screen.dart';
import 'package:ecommerce_flutter_app/screens/product_detail_screen.dart';
import 'package:ecommerce_flutter_app/screens/cart_screen.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const ECommerceApp(),
    ),
  );
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlMostShop',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: accentColor,
        ).copyWith(secondary: accentColor, background: bacgroundColor),
        scaffoldBackgroundColor: bacgroundColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => const HomeScreen(),
        '/category': (context) => CategoryProductsScreen(
          category: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/product': (context) => ProductDetailScreen(
          product: ModalRoute.of(context)!.settings.arguments as Product,
        ),
        '/cart': (context) => const CartScreen(),
        // Uncomment when LoginScreen and RegisterScreen are implemented
        // '/login': (context) => LoginScreen(),
        // '/register': (context) => RegisterScreen(),
      },
    );
  }
}
