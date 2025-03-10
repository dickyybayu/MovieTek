import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

class ApiService {
  final String baseUrl = "https://api.themoviedb.org/3";
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return movies;
      } else {
        throw Exception("Failed to load popular movies. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching popular movies: $e");
    }
  }

  Future<List<Movie>> fetchTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return movies;
      } else {
        throw Exception("Failed to load trending movies. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching trending movies: $e");
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception("Failed to load movie details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching movie details: $e");
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return movies;
      } else {
        throw Exception("Failed to search movies. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error searching movies: $e");
    }
  }
}