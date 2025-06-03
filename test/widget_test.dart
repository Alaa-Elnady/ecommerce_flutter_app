import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_flutter_app/screens/home_screen.dart';
import 'package:ecommerce_flutter_app/utils/constants.dart';

void main() {
  testWidgets('HomeScreen displays AppBar title and welcome text', (
    WidgetTester tester,
  ) async {
    // Build the HomeScreen widget
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: bacgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: textColor, fontFamily: 'Roboto'),
            bodyMedium: TextStyle(color: textColor, fontFamily: 'Roboto'),
          ),
          appBarTheme: AppBarTheme(backgroundColor: primaryColor),
        ),
        home: HomeScreen(),
      ),
    );

    // Verify the AppBar title
    expect(find.text('AlMostShop'), findsOneWidget);

    // Verify the welcome text
    expect(find.text('Welcome to AlMostShop Home!'), findsOneWidget);
  });
}
