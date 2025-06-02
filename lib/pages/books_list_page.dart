import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../services/api_services.dart';
import '../services/token_service.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  Map<String, dynamic>? scannedBook;
  bool isLoading = false;
  String? error;

  Future<void> scanAndFetchBook() async {
    setState(() {
      isLoading = true;
      error = null;
      scannedBook = null;
    });
    try {
      var result = await BarcodeScanner.scan();
      String scannedCode = result.rawContent;
      if (scannedCode.isEmpty) {
        setState(() {
          error = "Aucun code scanné.";
          isLoading = false;
        });
        return;
      }

      final bookInfo = await ApiService.getBookInfo(scannedCode);
      if (bookInfo == null) {
        setState(() {
          error = "Livre non trouvé pour le code-barres scanné.";
          isLoading = false;
        });
        return;
      }

      final userId = await TokenService.getUserId();
      if (userId == null) {
        setState(() {
          error = "Impossible de récupérer l'identifiant utilisateur. Veuillez vous reconnecter.";
          isLoading = false;
        });
        return;
      }

      setState(() {
        scannedBook = {
          'industry_identifiers_identifier': scannedCode,
          'title': bookInfo['title'] ?? 'Titre non disponible',
          'subtitle': '', // ou bookInfo['subtitle'] ?? ''
          'description': bookInfo['description'] ?? bookInfo['searchInfo']?['textSnippet'] ?? '',
          'page_count': bookInfo['pageCount'] ?? 0,
          'image_link_medium': bookInfo['imageLinks']?['medium']
              ?? bookInfo['imageLinks']?['thumbnail']
              ?? bookInfo['imageLinks']?['smallThumbnail']
              ?? '',
          'image_link_thumbnail': bookInfo['imageLinks']?['thumbnail']
              ?? bookInfo['imageLinks']?['smallThumbnail']
              ?? '',
          'author_name': (bookInfo['authors'] != null && bookInfo['authors'].isNotEmpty)
              ? bookInfo['authors'][0]
              : 'Auteur inconnu',
          'author_nickname': '',
          'author_birthday': null,
          'added_by_id': userId,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Erreur lors du scan ou de la récupération des données : $e";
        isLoading = false;
      });
    }
  }

  Future<void> sendBookToApi() async {
    if (scannedBook == null) return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      await ApiService.sendBookWithAuthor(scannedBook!);
      setState(() {
        scannedBook = null;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Livre envoyé à l'API !")),
      );
    } catch (e) {
      setState(() {
        error = "Erreur lors de l'envoi du livre : $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner un livre"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(error!, style: TextStyle(color: Colors.red)),
                      ),
                    if (scannedBook == null)
                      ElevatedButton(
                        onPressed: scanAndFetchBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                        ),
                        child: Text("Scanner un livre"),
                      ),
                    if (scannedBook != null) ...[
                      if (scannedBook!['image_link_thumbnail'] != null && scannedBook!['image_link_thumbnail'] != '')
                        Image.network(
                          scannedBook!['image_link_thumbnail'],
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80),
                        ),
                      SizedBox(height: 10),
                      Text(scannedBook!['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(scannedBook!['author_name'] ?? ''),
                      SizedBox(height: 10),
                      Text(scannedBook!['description'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendBookToApi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                        ),
                        child: Text("Enregistrer ce livre"),
                      ),
                      TextButton(
                        onPressed: scanAndFetchBook,
                        child: Text("Scanner un autre livre"),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class BookListPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  BookListPage({required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des livres"),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: () async {
          final userId = await TokenService.getUserId();
          final allBooks = await ApiService.fetchBooks();
          // Filtre strict sur l'id utilisateur (cast en string pour éviter les soucis de type)
          return allBooks.where((book) => book['added_by_id'].toString() == userId.toString()).toList();
        }(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: (book['image_link_thumbnail'] != null && book['image_link_thumbnail'] != '')
                    ? Image.network(
                        book['image_link_thumbnail'],
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                      )
                    : Icon(Icons.book),
                title: Text(book['title'] ?? ''),
                subtitle: Text(book['author_name'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? ''),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book['image_link_medium'] != null && book['image_link_medium'] != '')
              Image.network(
                book['image_link_medium'],
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80),
              ),
            SizedBox(height: 16),
            Text(book['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            SizedBox(height: 8),
            Text(book['author_name'] ?? '', style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 16),
            Text("Description :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(book['description'] ?? ''),
            SizedBox(height: 16),
            Text("Détails supplémentaires :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Nombre de pages : ${book['page_count'] ?? 'Inconnu'}"),
            // Ajoutez d'autres détails si nécessaire
          ],
        ),
      ),
    );
  }
}