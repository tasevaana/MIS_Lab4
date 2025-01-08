import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Joke> _favorites = [];

  List<Joke> get favorites => _favorites;

  bool isFavorite(Joke joke) {
    return _favorites.any((fav) => fav.id == joke.id);
  }

  void toggleFavorite(Joke joke) {
    if (isFavorite(joke)) {
      _favorites.removeWhere((fav) => fav.id == joke.id);
      notifyListeners();
    } else {
      _favorites.add(joke);
      notifyListeners();
    }
  }
}
