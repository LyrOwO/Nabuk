import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;

  const BookCard(this.title, this.author);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.book, color: const Color.fromRGBO(211, 180, 156, 50)),
        title: Text(title),
        subtitle: Text(author),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}