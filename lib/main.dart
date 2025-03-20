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
      debugShowCheckedModeBanner: false,
      title: 'Bibliothèque en Ligne',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(211, 180, 156, 50),
      ),
      initialRoute: '/login', // Démarrer sur la page de connexion
      routes: {
        '/': (context) => HomePage(), // HomePage as the default route
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


