import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Mon Profil'),
      ),
      body: Center(
        child: Text('Informations de profil...'), // Remplacez par votre contenu réel
      ),
      bottomNavigationBar: FooterNavigation(currentIndex: 5), // Index pour Profil
    );
  }
}
