import 'package:flutter/material.dart';
import '../pages/book_details_page.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;

  const BookCard(this.title, this.author);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.book, color: Color.fromRGBO(211, 180, 156, 50)),
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
                description:
                    "Ceci est une description fictive du livre '$title'. Vous pouvez personnaliser cette description dans votre base de données ou API.",
              ),
            ),
          );
        },
      ),
    );
  }
}
