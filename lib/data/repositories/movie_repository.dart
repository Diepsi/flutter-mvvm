import 'package:flutter_mvvm/models/movie_detail_model.dart';
import 'package:flutter_mvvm/models/movie_model.dart';
import 'package:flutter_mvvm/data/services/omdb_services.dart'; 

class MovieRepository {
  final OmdbServices _omdbService; 

  const MovieRepository ({required OmdbServices omdbService}) 
      : _omdbService = omdbService;

  Future<List<Movie>> fetchMovies(String query) async {
    try {
      final rawData = await _omdbService.getMovies(query);
      return rawData.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieDetailModel> getMovieDetail(String id) async {
    try {
      final json = await _omdbService.getMoviesDetail(id);
      return MovieDetailModel.fromJson(json); 
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi baru untuk mendapatkan data rekomendasi
  Future<List<Movie>> getRecommendations(String title) async {
    try {
      // Mengambil kata pertama dari judul sebagai keyword pencarian film serupa
      final firstWord = title.split(' ').first;
      return await fetchMovies(firstWord);
    } catch (e) {
      return [];
    }
  }
}