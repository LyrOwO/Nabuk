import 'package:flutter/material.dart';

class FooterNavigation extends StatelessWidget {
  final int currentIndex;

  const FooterNavigation({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Icône Accueil
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 0) Navigator.pushNamed(context, '/');
            },
          ),
          // Icône Livres
          IconButton(
            icon: Icon(
              Icons.book,
              color: currentIndex == 1 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 1) Navigator.pushNamed(context, '/books');
            },
          ),
          // Icône Étagères
          IconButton(
            icon: Icon(
              Icons.storage,
              color: currentIndex == 2 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 2) Navigator.pushNamed(context, '/shelves');
            },
          ),
          // Icône Prêts
          IconButton(
            icon: Icon(
              Icons.library_books,
              color: currentIndex == 3 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 3) Navigator.pushNamed(context, '/loans');
            },
          ),
          // Nouvelle icône pour Favoris
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: currentIndex == 4 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 4) Navigator.pushNamed(context, '/favorites');
            },
          ),
          // Icône Profil (dernier)
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 5 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 5) Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
