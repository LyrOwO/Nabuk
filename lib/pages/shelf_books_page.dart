import 'package:flutter/material.dart';
import '../services/api_services.dart';

class ShelfBooksPage extends StatefulWidget {
  final String shelfId;

  const ShelfBooksPage({required this.shelfId});

  @override
  _ShelfBooksPageState createState() => _ShelfBooksPageState();
}

class _ShelfBooksPageState extends State<ShelfBooksPage> {
  late Future<List<Map<String, dynamic>>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooksWithAuthors(); // Utiliser la méthode mise à jour
  }

  Future<List<Map<String, dynamic>>> _fetchBooksWithAuthors() async {
    final books = await ApiService.fetchBooksByShelf(widget.shelfId);
    return ApiService.fetchBooksWithAuthorNames(books); // Récupérer les noms des auteurs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livres de l\'étagère'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun livre trouvé.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final authorName = book['author_name'] ?? 'Auteur inconnu';

              return ListTile(
                title: Text(book['title'] ?? 'Titre inconnu'),
                subtitle: Text('Auteur : $authorName'), // Affiche le nom de l'auteur
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Action lors du clic sur un livre
                },
              );
            },
          );
        },
      ),
    );
  }
}
