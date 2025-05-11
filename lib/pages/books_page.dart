import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/book_card.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Map<String, dynamic>> books = []; // Changer le type en Map<String, dynamic>
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final fetchedBooks = await ApiService.fetchBooks();
      final booksWithAuthors = await ApiService.fetchBooksWithAuthorNames(fetchedBooks); // Récupérer les noms des auteurs
      if (mounted) { // Vérifier si le widget est toujours monté
        setState(() {
          books = booksWithAuthors.take(10).toList(); // Limite à 10 livres
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur : $e");
      if (mounted) { // Vérifier si le widget est toujours monté
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des livres : $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Livres disponibles'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? Center(child: Text('Aucun livre disponible.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final authorName = book['author_name'] ?? 'Auteur inconnu';

                    return BookCard(
                      title: book['title'] ?? 'Titre non disponible',
                      author: authorName, // Affiche le nom de l'auteur
                      imageUrl: book['image_link_thumbnail'], // Ajoutez l'URL de l'image
                      description: book['description'] ?? 'Description non disponible', // Ajoutez la description
                    );
                  },
                ),
    );
  }
}
