import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../services/token_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _token;  // Variable pour afficher le token

  Future<void> _login() async {
    final token = await ApiService.fetchToken(
      _usernameController.text,
      _passwordController.text,
    );

    if (token != null) {
      await TokenService.saveToken(token);

      setState(() {
        _token = token;
      });

       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connectez-vous',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              // Champ Email
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.login),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre username';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez entrer un username valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Champ Mot de Passe
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  } else if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              // Bouton de Connexion
              ElevatedButton(
                onPressed: () {
                  _login;
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez entrer votre username.")),
                    );
                    }  else if (!RegExp(r'^[\w-\.]{3,20}$').hasMatch(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez entrer un username valide.")),
                    );
                  } else if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez entrer votre mot de passe.")),
                    );
                  } else if (password.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Le mot de passe doit contenir au moins 6 caractères."),
                      ),
                    );
                  } else {
                    // Appelle la méthode de gestion de la connexion si tout est correct
                    //_handleLogin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  
                  backgroundColor: const Color.fromRGBO(211, 180, 156, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                
                child: const Text('Se connecter'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "Pas de compte ? Inscrivez-vous",
                  style: TextStyle(color: Color.fromRGBO(211, 180, 156, 50)),
                ),
              ),
              const SizedBox(height: 20),
              if (_token != null)
                Text(
                  'Token: $_token',
                  style: const TextStyle(color: Color.fromRGBO(211, 180, 156, 50), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Exemple de vérification simple (remplacez par une vraie logique backend)
    if (username == "admin" && password == "mdpadmin") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );
      // Redirection vers la page d'accueil ou autre
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username ou mot de passe incorrect')),
      );
    }
  }
}
