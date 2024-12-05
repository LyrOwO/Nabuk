import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//services/auth_service.dart
class AuthService {
  Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService(this._dio);

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = response.data; // Ensure this matches your API response
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
          return true;
        }
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  Future<bool> signup(String name, String email, String number, String password,
      String confirmPassword) async {
    try {
      final response = await _dio.post(
        '/register',
        data: jsonEncode({
          'username': username,
          'email': email,
          'birthday': birthday,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final token = response.data; // Ensure this matches your API response
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
          return true;
        }
      }
    } catch (e) {
      print('Signup error: $e');
    }
    return false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }