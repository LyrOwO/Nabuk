import 'package:flutter/material.dart';
import 'package:nabuk/viewmodels/Login_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: loginViewModel.usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: loginViewModel.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            loginViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      loginViewModel.login(context);
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}