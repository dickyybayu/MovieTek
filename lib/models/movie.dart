class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double rating;
  final String releaseDate;
  final List<int>? genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.rating,
    this.releaseDate = '',
    this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: json['genre_ids'] != null 
          ? List<int>.from(json['genre_ids']) 
          : null,
    );
  }

  String get fullPosterUrl => 
      posterPath.isNotEmpty 
          ? 'https://image.tmdb.org/t/p/w500$posterPath' 
          : 'https://via.placeholder.com/500x750?text=No+Image';
  
  String get fullBackdropUrl => 
      backdropPath != null && backdropPath!.isNotEmpty 
          ? 'https://image.tmdb.org/t/p/w500$backdropPath' 
          : 'https://via.placeholder.com/500x281?text=No+Image';

  String get year {
    if (releaseDate.isEmpty) return '';
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (_) {
      return '';
    }
  }

  String get formattedRating => rating.toStringAsFixed(1);

  List<String> getGenres() {
    if (genreIds == null) return [];
    
    final Map<int, String> genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Science Fiction',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    
    return genreIds!.map((id) => genreMap[id] ?? 'Unknown').toList();
  }
}