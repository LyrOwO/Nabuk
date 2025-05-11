import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/footer_navigation.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<int> _booksCountFuture;
  late Future<int> _shelvesCountFuture;
  late Future<int> _loansCountFuture;

  @override
  void initState() {
    super.initState();
    _booksCountFuture = _fetchBooksCount();
    _shelvesCountFuture = _fetchShelvesCount();
    _loansCountFuture = _fetchLoansCount();
  }

  Future<int> _fetchBooksCount() async {
    final books = await ApiService.fetchBooks();
    return books.length;
  }

  Future<int> _fetchShelvesCount() async {
    final shelves = await ApiService.fetchShelves();
    return shelves.length;
  }

  Future<int> _fetchLoansCount() async {
    final loans = await ApiService.fetchLoans();
    return loans.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom d'utilisateur
            Text(
              'Nom d\'utilisateur :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.username,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Nombre total de livres
            FutureBuilder<int>(
              future: _booksCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Chargement des livres...');
                } else if (snapshot.hasError) {
                  return Text('Erreur lors du chargement des livres.');
                }
                return Text(
                  'Nombre total de livres : ${snapshot.data}',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
            SizedBox(height: 20),

            // Nombre total d'étagères
            FutureBuilder<int>(
              future: _shelvesCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Chargement des étagères...');
                } else if (snapshot.hasError) {
                  return Text('Erreur lors du chargement des étagères.');
                }
                return Text(
                  'Nombre total d\'étagères : ${snapshot.data}',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
            SizedBox(height: 20),

            // Nombre total de prêts
            FutureBuilder<int>(
              future: _loansCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Chargement des prêts...');
                } else if (snapshot.hasError) {
                  return Text('Erreur lors du chargement des prêts.');
                }
                return Text(
                  'Nombre total de prêts : ${snapshot.data}',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(currentIndex: 5), // Icône de profil active
    );
  }
}
