import 'package:flutter/material.dart';
import '../widgets/book_card.dart'; // Assurez-vous que ce chemin est correct.

class BooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Livres disponibles'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Liste des livres sous forme de cartes
          BookCard('Le Petit Prince', 'Antoine de Saint-Exupéry'),
          BookCard('1984', 'George Orwell'),
          BookCard('Les Misérables', 'Victor Hugo'),
          BookCard('L\'Étranger', 'Albert Camus'),
        ],
      ),
    );
  }
}
