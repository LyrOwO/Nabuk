import 'package:flutter/material.dart';
import 'package:nabuk/pages/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/books_page.dart';
import 'pages/shelves_page.dart';
import 'pages/favorites_page.dart';
import 'pages/profile_page.dart';
import 'pages/loans_page.dart';
import 'pages/barcode_scanner_page.dart';
  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliothèque en Ligne',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/books': (context) => BooksPage(),
        '/shelves': (context) => ShelvesPage(),
        '/favorites': (context) => FavoritesPage(),
        '/profile': (context) => ProfilePage(),
        '/loans': (context) => LoansPage(),
        '/signup': (context) => SignupPage(),
        '/barcode_scanner': (context) => BarcodeScannerPage(),

      },
    );
  }
}
