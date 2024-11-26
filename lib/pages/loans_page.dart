import 'package:flutter/material.dart';
import 'add_loan_form.dart'; // Importez la page du formulaire si elle est dans un fichier séparé

class LoansPage extends StatefulWidget {
  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  // Données simulées pour les prêts
  List<Map<String, dynamic>> loans = [
    {
      'book': 'Le Petit Prince',
      'borrower': 'Alice',
      'dueDate': DateTime(2024, 11, 30),
    },
  ];

  // Fonction pour ouvrir le formulaire d'ajout
  void _openAddLoanForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLoanForm(
          onAddLoan: (newLoan) {
            setState(() {
              loans.add(newLoan);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Gestion des Prêts'),
      ),
      body: loans.isEmpty
    ? Center(child: Text('Aucun prêt enregistré.'))
    : ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            child: ListTile(
              title: Text(
                loan['book'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Emprunté par : ${loan['borrower']}'),
                  Text(
                    'Retour prévu : ${loan['dueDate'].toLocal()}'.split(' ')[0],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    loans.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        onPressed: _openAddLoanForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
