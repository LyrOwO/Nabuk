import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;
  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilise imageLinkThumbnail en priorité, sinon imageLinkMedium
    final imageUrl =
        (book['imageLinkThumbnail'] != null && book['imageLinkThumbnail'].toString().isNotEmpty)
            ? book['imageLinkThumbnail'].toString()
            : (book['imageLinkMedium']?.toString() ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Détail du livre'),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 16),
            if (imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 80),
                ),
              ),
            SizedBox(height: 8),
            Text(book['author_name'] ?? '', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(book['description'] ?? '', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
