import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart'; // Import the TokenService

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
    final token = await TokenService.getToken(); // Récupérer le token JWT
    if (token == null) {
      throw Exception('JWT Token not found');
    }

    // Étape 1 : Vérifier si l'auteur existe dans l'API
    final checkUrl = Uri.parse('$apiBaseUrl/api/authors?name=$name');
    final checkResponse = await http.get(
      checkUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajout du token ici
      },
    );

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
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajout du token ici aussi
      },
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
      final authorIri = await getOrCreateAuthor(
        name: bookData['author_name'],
        nickname: bookData['author_nickname'],
        birthday: bookData['author_birthday'] ?? '0000-01-01',
      );

      final userId = bookData['added_by_id'];
      final userIri = '/api/users/$userId';

      final payload = {
        'industry_identifiers_identifier': bookData['industry_identifiers_identifier'],
        'title': bookData['title'],
        'subtitle': bookData['subtitle'],
        'description': bookData['description'],
        'page_count': bookData['page_count'],
        'image_link_medium': bookData['image_link_medium'],
        'image_link_thumbnail': bookData['image_link_thumbnail'],
        'author': authorIri,
        'addedBy': userIri, // <-- IRI attendu par API Platform
      };

      print("Payload du livre avec auteur : $payload");

      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }

      final url = Uri.parse('$apiBaseUrl/api/books');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Réponse brute de l'API : ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['member'] == null || data['member'] is! List) {
          print("Aucun livre trouvé.");
          return [];
        }
        final books = data['member'] as List;
        return books.map((book) {
          return {
            'title': (book['title'] ?? 'Titre non disponible').toString(),
            'author': (book['author'] ?? 'Auteur inconnu').toString(),
            'description': (book['description'] ?? 'Description non disponible').toString(),
            'image_link_thumbnail': (book['displayImage'] ?? '').toString(),
          };
        }).toList();
      } else {
        throw Exception('Erreur lors de la récupération des livres : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des livres : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLoans() async {
    final url = Uri.parse('$apiBaseUrl/api/prets');
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['member'] == null || data['member'] is! List) {
          return [];
        }
        return List<Map<String, dynamic>>.from(data['member'].map((loan) => {
          'name_pret': loan['name_pret'],
          'date_debut_pret': loan['date_debut_pret'],
          'date_fin_pret': loan['date_fin_pret'],
        }));
      } else {
        throw Exception('Erreur lors de la récupération des prêts : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des prêts : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchShelves() async {
    final url = Uri.parse('$apiBaseUrl/api/shelves');
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['member'] == null || data['member'] is! List) {
          return [];
        }
        return List<Map<String, dynamic>>.from(data['member']);
      } else {
        throw Exception('Erreur lors de la récupération des étagères : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des étagères : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBooksByShelf(String shelfId) async {
    final url = Uri.parse('$apiBaseUrl/api/shelves/$shelfId');
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['books'] == null || data['books'] is! List) {
          return [];
        }
        final List<dynamic> bookUris = data['books'];
        List<Map<String, dynamic>> books = [];
        for (var bookUri in bookUris) {
          if (bookUri is String) {
            final bookResponse = await http.get(
              Uri.parse('$apiBaseUrl$bookUri'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );
            if (bookResponse.statusCode == 200) {
              books.add(jsonDecode(bookResponse.body));
            } else {
              print('Erreur lors de la récupération du livre : ${bookResponse.body}');
            }
          }
        }
        return books;
      } else {
        throw Exception('Erreur lors de la récupération des livres : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des livres : $e');
    }
  }

  static Future<Map<String, dynamic>?> fetchAuthorDetails(String authorUri) async {
    final url = Uri.parse('$apiBaseUrl$authorUri');
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de la récupération des détails de l\'auteur : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des détails de l\'auteur : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBooksWithAuthorNames(List<Map<String, dynamic>> books) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('JWT Token not found');
    }
    for (var book in books) {
      if (book['author'] is String) {
        final authorUri = book['author'];
        try {
          final authorDetails = await fetchAuthorDetails(authorUri);
          book['author_name'] = authorDetails?['name'] ?? 'Auteur inconnu';
        } catch (e) {
          book['author_name'] = 'Auteur inconnu';
        }
      } else {
        book['author_name'] = 'Auteur inconnu';
      }
    }
    return books;
  }

  static Future<dynamic> login(String username, String password) async {
    final url = Uri.parse('$apiBaseUrl/auth');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    // Pour compatibilité avec le code existant dans login_page.dart
    return {
      'statusCode': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }
}