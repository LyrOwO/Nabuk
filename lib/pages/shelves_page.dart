import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'shelf_books_page.dart';
import '../widgets/footer_navigation.dart';

class ShelvesPage extends StatefulWidget {
  @override
  _ShelvesPageState createState() => _ShelvesPageState();
}

class _ShelvesPageState extends State<ShelvesPage> {
  late Future<List<Map<String, dynamic>>> _shelvesFuture;

  @override
  void initState() {
    super.initState();
    _shelvesFuture = ApiService.fetchShelves(); // Récupérer les étagères
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(211, 180, 156, 50),
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

          // Liste des étagères
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _shelvesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune étagère trouvée.'));
                }

                final shelves = snapshot.data!;
                return ListView.builder(
                  itemCount: shelves.length,
                  itemBuilder: (context, index) {
                    final shelf = shelves[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.folder, color: Color.fromRGBO(211, 180, 156, 50)),
                        title: Text(shelf['name'] ?? 'Nom inconnu'),
                        subtitle: Text('Créé le : ${shelf['date_creation'] ?? 'Inconnu'}'), // Supprimé le nom de l'auteur
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShelfBooksPage(shelfId: shelf['id'].toString()), // Convertir en String
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Footer
      bottomNavigationBar: FooterNavigation(currentIndex: 2),
    );
  }
}
