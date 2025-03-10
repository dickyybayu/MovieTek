import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoritesProvider with ChangeNotifier {
  List<Movie> _favorites = [];
  static const String _favoritesKey = 'favorite_movies';

  FavoritesProvider() {
    _loadFavorites();
  }

  List<Movie> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      _favorites = favoritesJson.map((movieJson) {
        final movieMap = jsonDecode(movieJson);
        return Movie(
          id: movieMap['id'],
          title: movieMap['title'],
          overview: movieMap['overview'],
          posterPath: movieMap['posterPath'],
          backdropPath: movieMap['backdropPath'],
          rating: movieMap['rating'],
          releaseDate: movieMap['releaseDate'],
          genreIds: movieMap['genreIds'] != null 
            ? List<int>.from(movieMap['genreIds']) 
            : null,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final favoritesJson = _favorites.map((movie) {
        return jsonEncode({
          'id': movie.id,
          'title': movie.title,
          'overview': movie.overview,
          'posterPath': movie.posterPath,
          'backdropPath': movie.backdropPath,
          'rating': movie.rating,
          'releaseDate': movie.releaseDate,
          'genreIds': movie.genreIds,
        });
      }).toList();

      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  void addToFavorites(Movie movie) {
    if (!isFavorite(movie)) {
      _favorites.add(movie);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFromFavorites(Movie movie) {
    _favorites.removeWhere((m) => m.id == movie.id);
    _saveFavorites();
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      removeFromFavorites(movie);
    } else {
      addToFavorites(movie);
    }
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }
}