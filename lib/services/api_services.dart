import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String?> fetchToken(String username, String password) async {
    final url = Uri.parse('https://std25.beaupeyrat.com/auth');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }

  static Future<void> fetchData(String? token) async {
    final url = Uri.parse('https://std25.beaupeyrat.com/api/docs');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print('Erreur: ${response.statusCode}');
    }
  }

  static const String googleBooksBaseUrl = 'https://www.googleapis.com/books/v1';

  static Future<Map<String, dynamic>?> fetchBookByBarcode(String barcode) async {
    final url = Uri.parse('$googleBooksBaseUrl/volumes?q=isbn:$barcode');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['totalItems'] > 0) {
          return data['items'][0]['volumeInfo'];
        } else {
          return null; // No book found for the given barcode
        }
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données : $e');
    }
  }

  static Future<Map<String, dynamic>?> getBookInfo(String isbn) async {
    final url = Uri.parse('$googleBooksBaseUrl/volumes?q=isbn:$isbn');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('items')) {
          return data['items'][0]['volumeInfo'];
        } else {
          return null; // No book found for the given ISBN
        }
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données : $e');
    }
  }
}