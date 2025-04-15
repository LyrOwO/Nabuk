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

  static Future<void> sendBookData(Map<String, dynamic> bookData) async {
    final url = Uri.parse('$apiBaseUrl/api/books'); // Mettre à jour l'endpoint icici

    try {
      final payload = {
        'industry_identifiers_identifier': bookData['industry_identifiers_identifier'],
        'title': bookData['title'],
        'subtitle': bookData['subtitle'],
        'description': bookData['description'],
        'page_count': bookData['page_count'],
        'image_link_medium': bookData['image_link_medium'],
        'image_link_thumbnail': bookData['image_link_thumbnail'],
        'author_id': bookData['author_id'],
      };

      print("URL : $url"); // Log de l'URL
      print("Payload envoyé : $payload"); // Log du payload

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Statut de la réponse : ${response.statusCode}"); // Log du statut
      print("Réponse : ${response.body}"); // Log du corps de la réponse

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erreur: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi des données : $e');
    }
  }

  static Future<void> sendBookAndAuthorData(Map<String, dynamic> bookData) async {
    final url = Uri.parse('$apiBaseUrl/api/books'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'IndustryIdentifiersIdentifier': bookData['IndustryIdentifiersIdentifier'],
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

  static Future<bool> createAccount(String username, String password) async {
    final url = Uri.parse('$apiBaseUrl/signup'); // Vérifiez que cet endpoint est correct

    try {
      final payload = {
        'username': username,
        'password': password,
      };

      print("Payload envoyé : $payload"); // Log du payload
      print("URL : $url"); // Log de l'URL

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Statut de la réponse : ${response.statusCode}"); // Log du statut
      print("Réponse : ${response.body}"); // Log du corps de la réponse

      return response.statusCode == 201; // Retourne true si la création est réussie
    } catch (e) {
      throw Exception('Erreur lors de la création du compte : $e');
    }
  }

  static Future<int?> getOrCreateAuthor({
    required String name,
    String? nickname,
    required String birthday,
  }) async {
    final url = Uri.parse('$apiBaseUrl/api/authors'); // Endpoint pour gérer les auteurs

    try {
      // Vérifier si l'auteur existe déjà
      final checkUrl = Uri.parse('$apiBaseUrl/api/authors?name=$name');
      final checkResponse = await http.get(checkUrl, headers: {'Content-Type': 'application/json'});

      print("Statut de la réponse (vérification auteur) : ${checkResponse.statusCode}");
      print("Réponse brute (vérification auteur) : ${checkResponse.body}");

      if (checkResponse.statusCode == 200) {
        final data = jsonDecode(checkResponse.body);
        final members = data['member']; // Accéder à la liste des auteurs

        if (members != null && members.isNotEmpty) {
          // Parcourir les auteurs pour trouver une correspondance exacte
          for (var author in members) {
            if (author['name'] == name &&
                (author['nickname'] ?? '') == (nickname ?? '') &&
                author['birthday'] == birthday) {
              print("Auteur existant trouvé, ID : ${author['id']}"); // Log de l'ID de l'auteur existant
              return author['id']; // Retourne l'ID de l'auteur correspondant
            }
          }
        }
      }

      // Si aucun auteur correspondant n'est trouvé, tenter de le créer
      final payload = {
        'name': name,
        'nickname': nickname ?? '',
        'birthday': birthday,
      };

      print("Payload pour création d'auteur : $payload"); // Log du payload

      final createResponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Statut de la réponse (création auteur) : ${createResponse.statusCode}");
      print("Réponse brute (création auteur) : ${createResponse.body}");

      if (createResponse.statusCode == 201) {
        final data = jsonDecode(createResponse.body);
        print("Auteur créé avec succès, ID : ${data['id']}"); // Log de l'ID de l'auteur créé
        return data['id']; // Retourne l'ID de l'auteur créé
      } else if (createResponse.statusCode == 422) {
        // Gestion de l'erreur 422 : L'auteur existe déjà
        print("Erreur 422 : L'auteur existe déjà. Récupération de l'ID.");
        final data = jsonDecode(checkResponse.body);
        final members = data['member'];
        if (members != null && members.isNotEmpty) {
          for (var author in members) {
            if (author['name'] == name &&
                (author['nickname'] ?? '') == (nickname ?? '') &&
                author['birthday'] == birthday) {
              print("Auteur existant trouvé après erreur 422, ID : ${author['id']}");
              return author['id']; // Retourne l'ID de l'auteur correspondant
            }
          }
        }
      } else {
        throw Exception('Erreur lors de la création de l\'auteur : ${createResponse.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la gestion de l\'auteur : $e');
    }
  }
}