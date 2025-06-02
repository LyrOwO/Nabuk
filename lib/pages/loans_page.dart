import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/footer_navigation.dart';

class LoansPage extends StatefulWidget {
  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  List<Map<String, dynamic>> loans = []; // List to store loans
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLoans(); // Fetch loans when the page loads
  }

  Future<void> _fetchLoans() async {
    try {
      final fetchedLoans = await ApiService.fetchLoans(); // Fetch loans from the API
      setState(() {
        loans = fetchedLoans;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors de la récupération des prêts : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des prêts : $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Gestion des Prêts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : loans.isEmpty
              ? Center(child: Text('Aucun prêt enregistré.'))
              : ListView.builder(
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          loan['name_pret']?.toString() ?? '', // Sécurise le champ
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date de début : ${(loan['date_debut_pret'] ?? '').toString().split('T')[0]}'),
                            Text('Date de fin : ${(loan['date_fin_pret'] ?? '').toString().split('T')[0]}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Placeholder for delete functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Suppression à venir.')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: FooterNavigation(currentIndex: 3), // Activer l'icône des prêts
    );
  }
}
