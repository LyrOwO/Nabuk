import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiBaseUrl = 'https://std25.beaupeyrat.com';
  static const String googleBooksBaseUrl = 'https://www.googleapis.com/books/v1';

  static Future<String?> fetchToken(String username, String password) async {
    final url = Uri.parse('$apiBaseUrl/auth');

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
    final url = Uri.parse('$apiBaseUrl/api/docs');

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

  static Future<void> sendBookData(Map<String, String> bookData) async {
    final url = Uri.parse('$apiBaseUrl/books'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi des données : $e');
    }
  }

  static Future<void> sendBookAndAuthorData(Map<String, dynamic> bookData) async {
    final url = Uri.parse('$apiBaseUrl/books'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'isbn': bookData['isbn'],
          'title': bookData['title'],
          'subtitle': bookData['subtitle'],
          'description': bookData['description'],
          'page_count': bookData['page_count'],
          'image_link_medium': bookData['image_link_medium'],
          'image_link_thumbnail': bookData['image_link_thumbnail'],
          'author': {
            'name': bookData['author'],
          },
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi des données : $e');
    }
  }
}