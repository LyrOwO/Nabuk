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
          'subtitle': bookInfo['subtitle'] ?? '',
          'description': bookInfo['description'] ?? '',
          'page_count': bookInfo['pageCount'] ?? 0,
          'image_link_medium': bookInfo['imageLinks']?['medium'] ?? '',
          'image_link_thumbnail': bookInfo['imageLinks']?['thumbnail'] ?? '',
          'author_name': bookInfo['authors'] != null ? bookInfo['authors'][0] : 'Auteur inconnu',
          'author_nickname': '',
          'author_birthday': null,
          'added_by_id': userId, // Toujours non null ici
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
                        Image.network(scannedBook!['image_link_thumbnail'], height: 120),
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
