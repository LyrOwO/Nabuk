import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isAuthenticated = false;
 

  AuthProvider(this._authService);

 

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String username, String password) async {
    var success = await _authService.login(username, password);
    print(success);
    if (success) {
      _isAuthenticated = true;
      await _updateUser();
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup(String username, String password, String confirmPassword) async {
    bool success = await _authService.signup(username, password, confirmPassword);
    print(success);
    if (success) {
      _isAuthenticated = true;
      await _updateUser();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }

  

 
}