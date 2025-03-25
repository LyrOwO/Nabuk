import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../services/api_services.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  List<Map<String, String>> scannedBooks = []; // List to store scanned books

  @override
  void initState() {
    super.initState();
    scanBarcode(); // Automatically start scanning when the page is loaded
  }

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      String scannedCode = result.rawContent.isEmpty ? "Aucun code scanné" : result.rawContent;

      if (scannedCode.isNotEmpty) {
        // Fetch book details from Google Books API
        final bookInfo = await ApiService.getBookInfo(scannedCode);
        if (bookInfo != null) {
          setState(() {
            scannedBooks.add({
              'title': bookInfo['title'] ?? 'Titre non disponible',
              'imageURL': bookInfo['imageLinks']?['thumbnail'] ?? '',
            });
          });
          _showBookDialog(
            title: bookInfo['title'] ?? 'Titre non disponible',
            imageURL: bookInfo['imageLinks']?['thumbnail'] ?? '',
          );
        } else {
          _showErrorDialog("Livre non trouvé pour le code-barres scanné.");
        }
      } else {
        _showErrorDialog("Aucun code scanné.");
      }
    } catch (e) {
      _showErrorDialog("Erreur lors de la récupération des données : $e");
    }
  }

  void _showBookDialog({
    required String title,
    required String imageURL,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageURL.isNotEmpty)
                Image.network(imageURL, height: 150),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                scanBarcode(); // Continue scanning after closing the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(211, 180, 156, 50),
              ),
              child: Text("Scanner un autre"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _addAllBooksToLibrary() {
    // Simulate adding books to the library
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${scannedBooks.length} livres ajoutés à votre bibliothèque !")),
    );
    setState(() {
      scannedBooks.clear(); // Clear the list after adding books
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner de Codes-Barres"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: scannedBooks.length,
              itemBuilder: (context, index) {
                final book = scannedBooks[index];
                return ListTile(
                  leading: book['imageURL']!.isNotEmpty
                      ? Image.network(book['imageURL']!, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.book, size: 50),
                  title: Text(book['title']!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: scanBarcode, // Allow the user to manually start scanning again
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                  ),
                  child: Text("Continuer le Scan"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addAllBooksToLibrary, // Add all scanned books to the library
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                  ),
                  child: Text("Terminer et Ajouter Tous les Livres"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
