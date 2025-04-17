import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/book_card.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Map<String, String>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final fetchedBooks = await ApiService.fetchBooks();
      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des livres : $e')),
      );
      setState(() {
        isLoading = false;
      });
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
                    return BookCard(book['title']!, book['author']!);
                  },
                ),
    );
  }
}
