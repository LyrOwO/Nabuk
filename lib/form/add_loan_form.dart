import 'package:flutter/material.dart';

class AddLoanForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddLoan;

  AddLoanForm({required this.onAddLoan});

  @override
  _AddLoanFormState createState() => _AddLoanFormState();
}

class _AddLoanFormState extends State<AddLoanForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBook;
  String? _borrower;
  DateTime? _dueDate;

  // Liste simulée des livres disponibles
  List<String> availableBooks = ['Le Petit Prince', '1984', 'Dune', 'L\'Étranger'];

  // Ouvre un sélecteur de date
  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Ajouter un Prêt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ pour choisir un livre
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Livre'),
                items: availableBooks.map((book) {
                  return DropdownMenuItem(
                    value: book,
                    child: Text(book),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBook = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un livre.' : null,
              ),
              // Champ pour entrer le nom de l'emprunteur
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de l\'emprunteur'),
                onChanged: (value) {
                  setState(() {
                    _borrower = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Veuillez entrer un nom.' : null,
              ),
              // Sélecteur pour la date de retour
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Text(
                      _dueDate == null
                          ? 'Sélectionnez une date de retour'
                          : 'Date de retour : ${_dueDate!.toLocal()}'.split(' ')[0],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => _pickDueDate(context),
                      child: Text('Choisir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Bouton pour valider le formulaire
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _dueDate != null) {
                      widget.onAddLoan({
                        'book': _selectedBook,
                        'borrower': _borrower,
                        'dueDate': _dueDate,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ajouter le prêt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(211, 180, 156, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
