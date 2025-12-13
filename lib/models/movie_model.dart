import 'package:flutter_dotenv/flutter_dotenv.dart';

class Movie{
  final String title;
  final String year;
  final String poster;
  final String imdbID;

  const Movie({ 
    required this.title,
    required this.year,
    required this.poster,
    required this.imdbID,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'NO Title',
      year: json['Year'] ?? 'N/A', 
      poster: (json['Poster'] != null && json['Poster'] != 'N/A')
      ? json['Poster']
      : dotenv.env['DUMMY_POSTERURL'] ?? '', 
      imdbID: json['imdbID'] ?? '',
    ); 
  }
}