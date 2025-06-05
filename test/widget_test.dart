// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ecommerce_flutter_app/screens/home_screen.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';

// void main() {
//   testWidgets('HomeScreen displays AppBar title and welcome text', (
//     WidgetTester tester,
//   ) async {
//     // Build the HomeScreen widget
//     await tester.pumpWidget(
//       MaterialApp(
//         theme: ThemeData(
//           primaryColor: primaryColor,
//           scaffoldBackgroundColor: bacgroundColor,
//           textTheme: TextTheme(
//             bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//             bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//           ),
//           appBarTheme: AppBarTheme(backgroundColor: primaryColor),
//         ),
//         home: HomeScreen(),
//       ),
//     );

//     // Verify the AppBar title
//     expect(find.text('AlMostShop'), findsOneWidget);

//     // Verify the welcome text
//     expect(find.text('Welcome to AlMostShop Home!'), findsOneWidget);
//   });
// }

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ecommerce_flutter_app/screens/category_products_screen.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';

// void main() {
//   testWidgets(
//     'CategoryProductsScreen displays category title and product cards',
//     (WidgetTester tester) async {
//       // Build the CategoryProductsScreen widget with a test category
//       await tester.pumpWidget(
//         MaterialApp(
//           theme: ThemeData(
//             primaryColor: primaryColor,
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.green,
//               accentColor: accentColor,
//             ).copyWith(secondary: accentColor, background: bacgroundColor),
//             scaffoldBackgroundColor: bacgroundColor,
//             textTheme: const TextTheme(
//               bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//               bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//             ),
//           ),
//           home: const CategoryProductsScreen(category: 'electronics'),
//         ),
//       );

//       // Allow async operations (e.g., FutureBuilder) to complete
//       await tester.pumpAndSettle();

//       // Verify the AppBar title
//       expect(find.text('electronics'), findsOneWidget);

//       // Verify at least one product card (assuming API returns products)
//       expect(find.byType(Card), findsWidgets);
//     },
//   );
// }

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_flutter_app/screens/home_screen.dart';
import 'package:ecommerce_flutter_app/screens/search_screen.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

void main() {
  testWidgets(
    'HomeScreen search icon opens ProductSearchDelegate and displays results',
    (WidgetTester tester) async {
      // Build the HomeScreen widget
      await tester.pumpWidget(
        MaterialApp(
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
          ),
          home: const HomeScreen(),
          routes: {
            '/product': (context) =>
                const Placeholder(), // Mock ProductDetailScreen
          },
        ),
      );

      // Allow async operations to complete
      await tester.pumpAndSettle();

      // Verify the AppBar title
      expect(find.text('AlMostShop'), findsOneWidget);

      // Tap the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify SearchDelegate is open
      expect(find.byType(ProductSearchDelegate), findsOneWidget);

      // Enter a search query
      await tester.enterText(find.byType(TextField), 'shirt');
      await tester.pumpAndSettle();

      // Verify search results (assuming API returns products)
      expect(find.byType(Card), findsWidgets);
    },
  );
}


// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ecommerce_flutter_app/models/product.dart';
// import 'package:ecommerce_flutter_app/screens/home_screen.dart';
// import 'package:ecommerce_flutter_app/screens/product_detail_screen.dart';
// import 'package:ecommerce_flutter_app/screens/cart_screen.dart';
// import 'package:ecommerce_flutter_app/models/cart_item.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';

// // Mock SharedPreferences for testing
// class MockSharedPreferences {
//   String? savedData;
  
//   String? getString(String key) => savedData;
//   Future<bool> setString(String key, String value) async {
//     savedData = value;
//     return true;
//   }
// }

// // Testable CartModel that uses our mock
// class TestableCartModel extends CartModel {
//   final MockSharedPreferences mockPrefs = MockSharedPreferences();
  
//   @override
//   Future<void> _saveToPrefs() async {
//     final cartData = jsonEncode(_items.map((item) => item.toJson()).toList());
//     await mockPrefs.setString('cart', cartData);
//   }
  
//   @override
//   Future<void> loadFromPrefs() async {
//     final cartData = mockPrefs.getString('cart');
//     if (cartData != null) {
//       final List<dynamic> json = jsonDecode(cartData);
//       _items = json.map((item) => CartItem.fromJson(item)).toList();
//       notifyListeners();
//     }
//   }
// }

// // Test products
// final testProduct1 = Product(
//   id: '1',
//   name: 'Test Shirt',
//   description: 'Test product description',
//   price: 29.99,
//   image: 'https://example.com/image1.jpg',
//   category: 'Clothing',
//   discount: 5.0,
// );

// final testProduct2 = Product(
//   id: '2',
//   name: 'Test Jacket',
//   description: 'Test jacket description',
//   price: 59.99,
//   image: 'https://example.com/image2.jpg',
//   category: 'Clothing',
//   discount: 10.0,
// );

// // Fake API calls
// Future<List<Product>> fakeFetchProducts() async {
//   await Future.delayed(const Duration(milliseconds: 100));
//   return [testProduct1, testProduct2];
// }

// Future<List<String>> fakeFetchCategories() async {
//   await Future.delayed(const Duration(milliseconds: 100));
//   return ['Clothing', 'Electronics'];
// }

// void main() {
//   // Store original functions
//   late Future<List<Product>> Function() originalFetchProducts;
//   late Future<List<String>> Function() originalFetchCategories;

//   setUp(() {
//     originalFetchProducts = fetchProducts;
//     originalFetchCategories = fetchCategories;
//     fetchProducts = fakeFetchProducts;
//     fetchCategories = fakeFetchCategories;
    
//     // Initialize mock preferences
//     SharedPreferences.setMockInitialValues({});
//   });

//   tearDown(() {
//     fetchProducts = originalFetchProducts;
//     fetchCategories = originalFetchCategories;
//   });

//   // Helper function to build the app with CartModel
//   Widget buildTestApp(Widget home) {
//     return ChangeNotifierProvider(
//       create: (context) => TestableCartModel(),
//       child: MaterialApp(
//         title: 'AlMostShop',
//         theme: ThemeData(
//           primaryColor: primaryColor,
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.green,
//           ).copyWith(
//             secondary: accentColor,
//             background: backgroundColor,
//           ),
//           scaffoldBackgroundColor: backgroundColor,
//           textTheme: const TextTheme(
//             bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//             bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//         home: home,
//         routes: {
//           '/product': (context) => ProductDetailScreen(
//                 product: ModalRoute.of(context)!.settings.arguments as Product,
//               ),
//           '/cart': (context) => const CartScreen(),
//         },
//       ),
//     );
//   }

//   testWidgets('HomeScreen displays products', (WidgetTester tester) async {
//     await tester.pumpWidget(buildTestApp(const HomeScreen()));
//     await tester.pumpAndSettle(); // Wait for products to load
    
//     expect(find.text('Test Shirt'), findsOneWidget);
//     expect(find.text('Test Jacket'), findsOneWidget);
//   });

//   testWidgets('HomeScreen search works', (WidgetTester tester) async {
//     await tester.pumpWidget(buildTestApp(const HomeScreen()));
//     await tester.pumpAndSettle();
    
//     // Tap search icon
//     await tester.tap(find.byIcon(Icons.search));
//     await tester.pumpAndSettle();
    
//     // Enter search text
//     await tester.enterText(find.byType(TextField), 'shirt');
//     await tester.pumpAndSettle();
    
//     // Verify results
//     expect(find.text('Test Shirt'), findsOneWidget);
//     expect(find.text('Test Jacket'), findsNothing);
//   });

//   testWidgets('ProductDetailScreen shows product details', (tester) async {
//     await tester.pumpWidget(buildTestApp(
//       ProductDetailScreen(product: testProduct1),
//     ));
//     await tester.pumpAndSettle();
    
//     expect(find.text('Test Shirt'), findsNWidgets(2)); // Title and in body
//     expect(find.text('\$28.49'), findsOneWidget); // Discounted price
//     expect(find.text('5.0% off'), findsOneWidget);
//   });

//   testWidgets('Can add product to cart', (tester) async {
//     await tester.pumpWidget(buildTestApp(
//       ProductDetailScreen(product: testProduct1),
//     ));
//     await tester.pumpAndSettle();
    
//     // Tap add to cart button
//     await tester.tap(find.text('Add to Cart'));
//     await tester.pumpAndSettle();
    
//     // Verify snackbar appears
//     expect(find.text('Added 1 x Test Shirt to cart'), findsOneWidget);
//   });

//   testWidgets('CartScreen shows items and totals', (tester) async {
//     final cart = TestableCartModel();
//     cart.addProduct(testProduct1, 2); // This adds to cache automatically
    
//     await tester.pumpWidget(
//       ChangeNotifierProvider.value(
//         value: cart,
//         child: const MaterialApp(home: CartScreen()),
//       ),
//     );
//     await tester.pumpAndSettle();
    
//     // Verify items
//     expect(find.text('Test Shirt'), findsOneWidget);
//     expect(find.text('2'), findsOneWidget); // Quantity
//     expect(find.text('\$56.98'), findsOneWidget); // Total (2 * 28.49)
//   });

//   testWidgets('Can remove item from cart', (tester) async {
//     final cart = TestableCartModel();
//     cart.addProduct(testProduct1, 1);
    
//     await tester.pumpWidget(
//       ChangeNotifierProvider.value(
//         value: cart,
//         child: const MaterialApp(home: CartScreen()),
//       ),
//     );
//     await tester.pumpAndSettle();
    
//     // Verify item exists
//     expect(find.text('Test Shirt'), findsOneWidget);
    
//     // Tap delete button
//     await tester.tap(find.byIcon(Icons.delete));
//     await tester.pumpAndSettle();
    
//     // Verify empty state
//     expect(find.text('Your cart is empty'), findsOneWidget);
//   });

//   testWidgets('Can place order', (tester) async {
//     final cart = TestableCartModel();
//     cart.addProduct(testProduct1, 1);
    
//     await tester.pumpWidget(
//       ChangeNotifierProvider.value(
//         value: cart,
//         child: const MaterialApp(home: CartScreen()),
//       ),
//     );
//     await tester.pumpAndSettle();
    
//     // Place order
//     await tester.tap(find.text('Place Order'));
//     await tester.pumpAndSettle();
    
//     // Verify success message
//     expect(find.text('Order placed successfully'), findsOneWidget);
//     expect(find.text('Your cart is empty'), findsOneWidget);
//   });
// }