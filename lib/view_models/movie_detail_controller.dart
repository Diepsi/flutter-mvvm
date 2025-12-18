import 'package:get/get.dart';
import 'package:flutter_mvvm/data/repositories/movie_repository.dart';
import 'package:flutter_mvvm/models/movie_detail_model.dart';
import 'package:flutter_mvvm/models/movie_model.dart'; // Tambahkan import model movie

class MovieDetailController extends GetxController {
  final MovieRepository _repository;

  MovieDetailController({required MovieRepository repository}) : _repository = repository;

  final RxBool isLoading = false.obs; 
  final Rxn<MovieDetailModel> movieDetail = Rxn<MovieDetailModel>(); 
  final RxString errorMessage = ''.obs; 
  
  // Baris Baru: Menampung daftar rekomendasi
  final RxList<Movie> recommendations = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is String) {
      fetchDetail(args);
    }
  }

  void fetchDetail(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      recommendations.clear(); // Bersihkan rekomendasi sebelumnya

      final result = await _repository.getMovieDetail(id);
      movieDetail.value = result;

      // Ambil rekomendasi jika data film utama ditemukan
      if (result != null) {
        final List<Movie> fetchedRecs = await _repository.getRecommendations(result.title);
        // Filter agar film yang sedang dibuka tidak muncul kembali di daftar rekomendasi
        recommendations.value = fetchedRecs.where((m) => m.imdbID != id).toList();
      }
    } catch (e) {
      errorMessage.value = 'Terjadi Kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}