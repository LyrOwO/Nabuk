import 'package:flutter/material.dart';
import 'package:nabuk/viewmodel/signup_viewmodel.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<SignupPasswordViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: signupViewModel.updateName,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              onChanged: signupViewModel.updateEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: signupViewModel.updatePhone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: signupViewModel.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: signupViewModel.confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            signupViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      signupViewModel.signup(context);
                    },
                    child: const Text('Signup'),
                  ),
          ],
        ),
      ),
    );
  }
}