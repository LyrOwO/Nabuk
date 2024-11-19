import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';
import '../widgets/book_card.dart';

class BooksPage extends StatelessWidget {
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
                  'Tous les Livres',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Faux contenu : Liste de livres
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return BookCard('Livre ${index + 1}', 'Auteur ${index + 1}');
                },
              ),
            ),
          ),

          // Footer
          FooterNavigation(currentIndex: 1),
        ],
      ),
    );
  }
}