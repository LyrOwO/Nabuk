import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';
import '../widgets/book_card.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(211, 180, 156, 50),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Favoris',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Faux contenu : Livres favoris
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  BookCard('Le Seigneur des Anneaux', 'J.R.R. Tolkien'),
                  BookCard('Harry Potter', 'J.K. Rowling'),
                  BookCard('Le Comte de Monte-Cristo', 'Alexandre Dumas'),
                ],
              ),
            ),
          ),

          // Footer
          FooterNavigation(currentIndex: 2),
        ],
      ),
    );
  }
}