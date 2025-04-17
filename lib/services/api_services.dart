import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiBaseUrl = 'https://std25.beaupeyrat.com';
  static const String googleBooksBaseUrl = 'https://www.googleapis.com/books/v1';

  // Set pour stocker les auteurs vérifiés ou créés
  static final Set<Map<String, String>> _authorsSet = {};

  // Méthode pour vérifier si un auteur existe dans le Set
  static int? getAuthorIdFromSet(String name, String? nickname, String birthday) {
    for (var author in _authorsSet) {
      if (author['name'] == name) {
        return int.tryParse(author['id']!); // Retourne l'ID si trouvé
      }
    }
    return null; // Retourne null si l'auteur n'existe pas
  }

  // Méthode pour ajouter un auteur au Set
  static void addAuthorToSet(int id, String name, String? nickname, String birthday) {
    _authorsSet.add({
      'id': id.toString(),
      'name': name,
      'nickname': nickname ?? '',
      'birthday': birthday,
    });
  }

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
      // Préparer le payload avec les données du livre et de l'auteur
      final payload = {
        'IndustryIdentifiersIdentifier': bookData['IndustryIdentifiersIdentifier'],
        'title': bookData['title'],
        'subtitle': bookData['subtitle'],
        'description': bookData['description'],
        'page_count': bookData['page_count'],
        'image_link_medium': bookData['image_link_medium'],
        'image_link_thumbnail': bookData['image_link_thumbnail'],
        'author': {
          'name': bookData['author_name'],
          'nickname': bookData['author_nickname'],
          'birthday': bookData['author_birthday'],
        },
      };

      print("Payload envoyé : $payload"); // Log pour vérifier le payload

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Statut de la réponse : ${response.statusCode}"); // Log du statut
      print("Réponse : ${response.body}"); // Log du corps de la réponse

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Si la requête réussit, vérifier si un nouvel ID d'auteur est retourné
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('author_id')) {
          print("Nouvel ID de l'auteur : ${responseData['author_id']}");
        } else {
          print("Aucun nouvel ID d'auteur retourné.");
        }
      } else {
        throw Exception('Erreur: ${response.statusCode} - ${response.body}');
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

  // Méthode pour vérifier ou créer un auteur et retourner une IRI
  static Future<String> getOrCreateAuthor({
    required String name,
    String? nickname,
    required String birthday,
  }) async {
    // Étape 1 : Vérifier si l'auteur existe dans l'API
    final checkUrl = Uri.parse('$apiBaseUrl/api/authors?name=$name');
    final checkResponse = await http.get(checkUrl, headers: {'Content-Type': 'application/json'});

    print("Statut de la réponse (vérification auteur) : ${checkResponse.statusCode}");
    print("Réponse brute (vérification auteur) : ${checkResponse.body}");

    if (checkResponse.statusCode == 200) {
      final data = jsonDecode(checkResponse.body);
      final members = data['member'];

      if (members != null && members.isNotEmpty) {
        for (var author in members) {
          if (author['name'] == name) {
            final iri = author['@id']; // Récupérer l'IRI de l'auteur
            print("Auteur existant trouvé, IRI : $iri");
            return iri;
          }
        }
      }
    }

    // Étape 2 : Si l'auteur n'existe pas, le créer
    final payload = {
      'name': name,
      'nickname': nickname ?? '',
      'birthday': birthday,
    };

    print("Payload pour création d'auteur : $payload");

    final createResponse = await http.post(
      Uri.parse('$apiBaseUrl/api/authors'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print("Statut de la réponse (création auteur) : ${createResponse.statusCode}");
    print("Réponse brute (création auteur) : ${createResponse.body}");

    if (createResponse.statusCode == 201) {
      final data = jsonDecode(createResponse.body);
      final iri = data['@id']; // Récupérer l'IRI de l'auteur créé
      print("Auteur créé avec succès, IRI : $iri");
      return iri;
    } else {
      throw Exception('Erreur lors de la création de l\'auteur : ${createResponse.body}');
    }
  }

  // Méthode pour envoyer un livre avec l'IRI de l'auteur
  static Future<void> sendBookWithAuthor(Map<String, dynamic> bookData) async {
    try {
      // Étape 1 : Vérifier ou créer l'auteur et récupérer son IRI
      final authorIri = await getOrCreateAuthor(
        name: bookData['author_name'],
        nickname: bookData['author_nickname'],
        birthday: bookData['author_birthday'] ?? '1900-01-01', // Date par défaut si inconnue
      );

      // Étape 2 : Envoyer le livre avec l'IRI de l'auteur
      final payload = {
        'industry_identifiers_identifier': bookData['industry_identifiers_identifier'],
        'title': bookData['title'],
        'subtitle': bookData['subtitle'],
        'description': bookData['description'],
        'page_count': bookData['page_count'],
        'image_link_medium': bookData['image_link_medium'],
        'image_link_thumbnail': bookData['image_link_thumbnail'],
        'author': authorIri, // Utiliser l'IRI de l'auteur
      };

      print("Payload du livre avec auteur : $payload");

      final url = Uri.parse('$apiBaseUrl/api/books');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Statut de la réponse : ${response.statusCode}");
      print("Réponse : ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erreur lors de l\'envoi du livre : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du livre avec auteur : $e');
    }
  }

  static Future<List<Map<String, String>>> fetchBooks() async {
    final url = Uri.parse('$apiBaseUrl/api/books');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final books = data['hydra:member'] as List;

        return books.map((book) {
          return {
            'title': (book['title'] ?? 'Titre non disponible').toString(),
            'author': (book['author']['name'] ?? 'Auteur inconnu').toString(),
          };
        }).toList();
      } else {
        throw Exception('Erreur lors de la récupération des livres : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des livres : $e');
    }
  }
}