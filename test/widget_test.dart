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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_flutter_app/screens/category_products_screen.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

void main() {
  testWidgets(
    'CategoryProductsScreen displays category title and product cards',
    (WidgetTester tester) async {
      // Build the CategoryProductsScreen widget with a test category
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
          home: const CategoryProductsScreen(category: 'electronics'),
        ),
      );

      // Allow async operations (e.g., FutureBuilder) to complete
      await tester.pumpAndSettle();

      // Verify the AppBar title
      expect(find.text('electronics'), findsOneWidget);

      // Verify at least one product card (assuming API returns products)
      expect(find.byType(Card), findsWidgets);
    },
  );
}
