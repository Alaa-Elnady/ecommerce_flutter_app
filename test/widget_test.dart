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
// import 'package:ecommerce_flutter_app/models/product.dart';
// import 'package:ecommerce_flutter_app/screens/home_screen.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';

// // Fake fetchProducts for testing
// Future<List<Product>> fakeFetchProducts() async {
//   return [
//     Product(
//       id: '1',
//       name: 'Test Shirt',
//       description: 'A test shirt',
//       price: 29.99,
//       image: 'https://example.com/shirt.jpg',
//       category: "men's clothing",
//     ),
//     Product(
//       id: '2',
//       name: 'Test Jacket',
//       description: 'A test jacket',
//       price: 59.99,
//       image: 'https://example.com/jacket.jpg',
//       category: "men's clothing",
//     ),
//   ];
// }

// // Fake fetchCategories for testing
// Future<List<String>> fakeFetchCategories() async {
//   return ["men's clothing", 'electronics'];
// }

// void main() {
//   testWidgets('HomeScreen search icon opens search bar and displays results', (WidgetTester tester) async {
//     // Store original fetchProducts and fetchCategories
//     final originalFetchProducts = fetchProducts;
//     final originalFetchCategories = fetchCategories;

//     // Override with fake implementations
//     fetchProducts = fakeFetchProducts;
//     fetchCategories = fakeFetchCategories;

//     // Build the HomeScreen widget
//     await tester.pumpWidget(
//       MaterialApp(
//         theme: ThemeData(
//           primaryColor: primaryColor,
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.green,
//             accentColor: accentColor,
//           ).copyWith(
//             secondary: accentColor,
//             background: bacgroundColor,
//           ),
//           scaffoldBackgroundColor: bacgroundColor,
//           textTheme: const TextTheme(
//             bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//             bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//           ),
//         ),
//         home: const HomeScreen(),
//         routes: {
//           '/product': (context) => const Placeholder(), // Mock ProductDetailScreen
//         },
//       ),
//     );

//     // Allow async operations to complete
//     await tester.pumpAndSettle();

//     // Verify the AppBar title
//     expect(find.text('AlMostShop'), findsOneWidget);

//     // Tap the search icon
//     await tester.tap(find.byIcon(Icons.search));
//     await tester.pumpAndSettle();

//     // Verify the search bar is open by checking for the TextField
//     expect(find.byType(TextField), findsOneWidget);

//     // Enter a search query
//     await tester.enterText(find.byType(TextField), 'shirt');
//     await tester.pumpAndSettle();

//     // Verify search results
//     expect(find.text('Test Shirt'), findsOneWidget);
//     expect(find.byType(Card), findsOneWidget);

//     // Restore original fetchProducts and fetchCategories
//     fetchProducts = originalFetchProducts;
//     fetchCategories = originalFetchCategories;
//   });
// }


// -----------------------------------------------------------------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ecommerce_flutter_app/models/product.dart';
// import 'package:ecommerce_flutter_app/screens/home_screen.dart';
// import 'package:ecommerce_flutter_app/utils/constants.dart';

// // Fake fetchProducts for testing
// Future<List<Product>> fetchProducts() async {
//   return [
//     Product(
//       id: '1',
//       name: 'Test Shirt',
//       description: 'Test product description',
//       price: 29.999,
//       image: 'https://example.com/image1.jpg',
//       category: 'Clothing',
//       discount: 5.0,
//     ),
//     Product(
//       id: '2',
//       name: 'Test Jacket',
//       description: 'Test jacket description',
//       price: 59.999,
//       image: 'https://example.com/image2.jpg',
//       category: 'Clothing',
//       discount: 10.0,
//     ),
//   ];
// }

// // Fake fetchCategories for testing
// Future<List<String>> fetchCategories() async {
//   return ['Clothing', 'Electronics'];
// }

// void main() {
//   testWidgets('HomeScreen search icon opens search bar and displays results', (WidgetTester tester) async {
//     // Store original fetch functions
//     final originalFetchProducts = fetchProducts;
//     final originalFetchCategories = fetchCategories;

//     // Override with fake implementations
//     fetchProducts = fetchProducts;
//     fetchCategories = fetchCategories;

//     // Build the HomeScreen widget
//     await tester.pumpWidget(
//       MaterialApp(
//         title: 'AlmostShop',
//         theme: ThemeData(
//           primaryColor: primaryColor,
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.green,
//           ).copyWith(
//             secondary: accentColor,
//             background: bacgroundColor,
//           scaffoldBackgroundColor: bacgroundColor,
//           textTheme: const TextTheme(
//             bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
//             bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
//           ),
//         ),
//         home: const HomeScreen(),
//         routes: {
//           '/product': (context) => const Placeholder(), // Mock ProductDetailScreen
//         },
//       ),
//     );

//     // Allow async operations to complete
//     await tester.pumpAndSettle();

//     // Verify the AppBar title
//     expect(find.text('AlMostShop'), findsOneWidget);

//     // Tap the search icon
//     await tester.tap(find.byIcon(Icons.search));
//     await tester.pumpAndSettle();

//     // Verify the search bar is open by checking for the TextField
//     expect(find.byType(TextField), findsOneWidget);

//     // Enter a search query
//     await tester.enterText(find.byType(TextField), 'shirt');
//     await tester.pumpAndSettle();

//     // Verify search results
//     expect(find.text('Test Shirt'), findsOneWidget);
//     expect(find.byType(Card), findsOneWidget);

//     // Restore original fetch functions
//     fetchProducts = originalFetchProducts;
//     fetchCategories = originalFetchCategories;
//   });
// }