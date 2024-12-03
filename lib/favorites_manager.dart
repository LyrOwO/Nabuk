import 'package:flutter/material.dart';

class FavoritesManager extends ChangeNotifier {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void toggleFavorite(String book) {
    if (_favorites.contains(book)) {
      _favorites.remove(book);
    } else {
      _favorites.add(book);
    }
    notifyListeners(); // Notifie les widgets qui écoutent les changements
  }

  bool isFavorite(String book) {
    return _favorites.contains(book);
  }
}
