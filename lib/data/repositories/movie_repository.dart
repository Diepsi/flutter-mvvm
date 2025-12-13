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

  // Perbaikan Tipe dan Model
  Future<MovieDetailModel> getMovieDetail(String id) async {
    try {
      // Perbaikan: Ganti getMovies menjadi getMoviesDetail
      final json = await _omdbService.getMoviesDetail(id);

      // Perbaikan: Ganti MovieDetail menjadi MovieDetailModel
      // Perbaikan: Ganti fromjson menjadi fromJson
      return MovieDetailModel.fromJson(json); 
    } catch (e) {
      rethrow;
    }
  }
}