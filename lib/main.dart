import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/books_page.dart';
import 'pages/favorites_page.dart';
import 'pages/profile_page.dart';

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
        '/books': (context) => BooksPage(),
        '/favorites': (context) => FavoritesPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}