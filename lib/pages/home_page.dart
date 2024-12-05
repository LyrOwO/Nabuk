import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';
import '../widgets/book_card.dart';

class HomePage extends StatelessWidget {
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
                  'Bienvenue à la Bibliothèque',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Rechercher un livre...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Faux contenu : Suggestions de livres
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Suggestions pour vous',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  BookCard('Les Misérables', 'Victor Hugo'),
                  BookCard('1984', 'George Orwell'),
                  BookCard('Le Petit Prince', 'Antoine de Saint-Exupéry'),
                  BookCard('Moby Dick', 'Herman Melville'),
                ],
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(211, 180, 156, 50),
            ),
            child: Text('Se connecter'),
          ),
          // Footer
          FooterNavigation(currentIndex: 0),
        ],
      ),
    );
  }
}