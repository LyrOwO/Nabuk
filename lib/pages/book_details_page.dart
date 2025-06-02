import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final String? imageLinkThumbnail;
  final String? imageLinkMedium;

  const BookDetailsPage({
    required this.title,
    required this.author,
    required this.description,
    this.imageLinkThumbnail,
    this.imageLinkMedium,
  });

  @override
  Widget build(BuildContext context) {
    // Utilise imageLinkThumbnail en priorité, sinon imageLinkMedium
    final imageUrl = (imageLinkThumbnail != null && imageLinkThumbnail!.isNotEmpty)
        ? imageLinkThumbnail!
        : (imageLinkMedium ?? '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Détails du livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
            SizedBox(height: 10),
            Text(
              'Auteur : $author',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
