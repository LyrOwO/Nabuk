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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Empêche de quitter la page
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(211, 180, 156, 50),
          title: Text('Connexion'),
          automaticallyImplyLeading: false, // Supprime le bouton "back" dans l'AppBar
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
                ),
                SizedBox(height: 32),
                // Bouton de Connexion
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(211, 180, 156, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('Se connecter'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await ApiService.fetchToken(username, password);
      if (token != null) {
        await TokenService.saveToken(token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie !')),
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
