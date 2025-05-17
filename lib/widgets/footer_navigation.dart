import 'package:flutter/material.dart';

class FooterNavigation extends StatelessWidget {
  final int currentIndex;

  const FooterNavigation({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/books');
            break;
          case 2:
            Navigator.pushNamed(context, '/shelves');
            break;
          case 3:
            Navigator.pushNamed(context, '/loans');
            break;
          case 4:
            Navigator.pushNamed(context, '/barcode_scanner');
            break;
          case 5:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color.fromRGBO(211, 180, 156, 50),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Livres'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Étagères'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Prêts'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
