import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/book_card.dart';
import '../services/token_service.dart'; // Ajoute cette ligne pour importer TokenService

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  int _currentMax = 20; // Nombre de livres à afficher initialement et à chaque scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoading) {
      setState(() {
        if (_currentMax < books.length) {
          _currentMax += 20; // Charge 20 livres de plus à chaque fois
        }
      });
    }
  }

  Future<void> _fetchBooks() async {
    try {
      final fetchedBooks = await ApiService.fetchBooks();
      final booksWithAuthors = await ApiService.fetchBooksWithAuthorNames(fetchedBooks);

      final userId = await TokenService.getUserId();

      final userBooks = booksWithAuthors.where((book) {
        final bookUserId = book['added_by_id']?.toString().trim();
        final currentUserId = userId?.toString().trim();
        return bookUserId != null && bookUserId.isNotEmpty && bookUserId == currentUserId;
      }).toList();

      if (mounted) {
        setState(() {
          books = userBooks;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur : $e");
      if (mounted) {
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
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: (_currentMax < books.length) ? _currentMax : books.length,
                  itemBuilder: (context, index) {
                    if (index >= books.length) return null;
                    final book = books[index];
                    final authorName = book['author_name'] ?? 'Auteur inconnu';
                    // Affiche imageLinkThumbnail en priorité, sinon imageLinkMedium
                    final imageUrl = book['imageLinkThumbnail'] != null && book['imageLinkThumbnail'] != ''
                        ? book['imageLinkThumbnail']
                        : (book['imageLinkMedium'] ?? '');

                    return BookCard(
                      title: book['title'] ?? 'Titre non disponible',
                      author: authorName,
                      imageUrl: imageUrl,
                      description: book['description'] ?? 'Description non disponible',
                    );
                  },
                ),
    );
  }
}
