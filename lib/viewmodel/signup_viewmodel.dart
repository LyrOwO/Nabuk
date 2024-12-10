import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nabuk/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupPasswordViewModel extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? Name;
  String? Username;
  String? Phone;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateName(String? name) {
    Name = name;
    notifyListeners();
  }

  void updateEmail(String? email) {
    Username = email;
    notifyListeners();
  }

  void updatePhone(String? phone) {
    Phone = phone;
    notifyListeners();
  }

  Future<void> signup(BuildContext context) async {
    if (_validatePasswords()) {
      setLoading(true);
  
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signup(
        Name!,
        Username!,
        Phone!,
        passwordController.text.trim(),
        confirmPasswordController.text.trim(),
      );

      setLoading(false);
      print(success);
      if (success) {
        print('Signup successful');
        Navigator.pushNamed(context, '/'); //you can do this routing by your method too
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed! Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match or are invalid')),
      );
    }
  }

  bool _validatePasswords() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;


    return password == confirmPassword &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }

  

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}