import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/footer_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _booksFuture;
  late Future<List<Map<String, dynamic>>> _shelvesFuture;
  late Future<List<Map<String, dynamic>>> _loansFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks();
    _shelvesFuture = ApiService.fetchShelves();
    _loansFuture = ApiService.fetchLoans();
  }

  Future<List<Map<String, dynamic>>> _fetchBooks() async {
    final books = await ApiService.fetchBooks();
    books.shuffle(); // Mélanger les livres pour un affichage aléatoire
    return books.take(4).toList(); // Retourner les 4 premiers livres
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nabuk'),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50), // Couleur habituelle
        centerTitle: true, // Centrer le titre
        elevation: 0, // Supprimer l'ombre
        automaticallyImplyLeading: false, // Désactiver la flèche de retour
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Livres
            _buildSection(
              title: 'Livres',
              future: _booksFuture,
              itemBuilder: (context, book) => ListTile(
                title: Text(book['title'] ?? 'Titre non disponible'),
                subtitle: Text(book['author_name'] ?? 'Auteur inconnu'),
              ),
              onSeeAllPressed: () {
                Navigator.pushNamed(context, '/books');
              },
            ),

            // Section Étagères
            _buildSection(
              title: 'Étagères',
              future: _shelvesFuture,
              itemBuilder: (context, shelf) => ListTile(
                title: Text(shelf['name'] ?? 'Nom inconnu'),
                subtitle: Text('Créé le : ${shelf['date_creation'] ?? 'Inconnu'}'),
              ),
              onSeeAllPressed: () {
                Navigator.pushNamed(context, '/shelves');
              },
              maxItems: 2,
            ),

            // Section Prêts
            _buildSection(
              title: 'Prêts',
              future: _loansFuture,
              itemBuilder: (context, loan) => ListTile(
                title: Text(loan['name_pret'] ?? 'Nom du prêt inconnu'),
                subtitle: Text(
                  'Début : ${loan['date_debut_pret'] ?? 'Inconnu'}\nFin : ${loan['date_fin_pret'] ?? 'Inconnu'}',
                ),
              ),
              onSeeAllPressed: () {
                Navigator.pushNamed(context, '/loans');
              },
              maxItems: 2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(currentIndex: 0),
    );
  }

  Widget _buildSection({
    required String title,
    required Future<List<Map<String, dynamic>>> future,
    required Widget Function(BuildContext, Map<String, dynamic>) itemBuilder,
    required VoidCallback onSeeAllPressed,
    int maxItems = 4,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with "See All" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: onSeeAllPressed,
              ),
            ],
          ),

          // Content
          FutureBuilder<List<Map<String, dynamic>>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucun élément trouvé.'));
              }

              final items = snapshot.data!.take(maxItems).toList();
              return Column(
                children: items.map((item) => itemBuilder(context, item)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}