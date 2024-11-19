import 'package:flutter/material.dart';
import '../widgets/footer_navigation.dart';

class ShelvesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(211, 180, 156, 50), // Utilisation de la nouvelle couleur
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Mes Étagères',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Faux contenu : Liste des étagères
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _shelfCard('Romans'),
                  _shelfCard('Science-fiction'),
                  _shelfCard('Biographies'),
                  _shelfCard('À lire plus tard'),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bouton flottant correctement positionné
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0), // Ajustement pour éviter de recouvrir le footer
        child: FloatingActionButton(
          onPressed: () {
            // Placeholder : Pour ajouter une nouvelle étagère dans le futur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fonction d’ajout à venir !')),
            );
          },
          backgroundColor: Color.fromRGBO(211, 180, 156, 50), // Nouvelle couleur
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),

      // Footer
      bottomNavigationBar: FooterNavigation(currentIndex: 2),
    );
  }

  Widget _shelfCard(String shelfName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.folder, color: Color.fromRGBO(211, 180, 156, 50)),
        title: Text(shelfName),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Placeholder : Pour visualiser les livres de cette étagère dans le futur
        },
      ),
    );
  }
}
