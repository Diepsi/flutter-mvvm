import 'package:get/get.dart';
import 'package:flutter_mvvm/models/movie_model.dart';
import 'package:flutter_mvvm/data/repositories/movie_repository.dart';

class MovieController extends GetxController {
  final MovieRepository _repository;

  MovieController({required MovieRepository repository}) : _repository = repository;

  var movieList = <Movie>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void searchMovies(String query) async {
    if (query.isEmpty) return;

    try{
      isLoading.value = true;
      errorMessage.value = '';

      final movies = await _repository.fetchMovies(query);

      if (movies.isNotEmpty) {
        movieList.value = movies;
      } else {
        movieList.clear();
        errorMessage.value = 'Film tidak ditemukan';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi Kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}