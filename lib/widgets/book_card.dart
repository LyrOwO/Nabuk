import 'package:flutter/material.dart';
import '../pages/book_details_page.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String? imageUrl;
  final String description;

  const BookCard({
    required this.title,
    required this.author,
    this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.grey, size: 50);
                },
              )
            : Icon(Icons.book, color: Color.fromRGBO(211, 180, 156, 50)),
        title: Text(title),
        subtitle: Text(author),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsPage(
                title: title,
                author: author,
                description: description,
              ),
            ),
          );
        },
      ),
    );
  }
}
