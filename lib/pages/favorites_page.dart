import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Mes Favoris'),
      ),
      body: Center(
        child: Text('Liste des livres favoris...'), // Remplacez par votre contenu réel
      ),
      bottomNavigationBar: FooterNavigation(currentIndex: 4), // Index pour Favoris
    );
  }
}
