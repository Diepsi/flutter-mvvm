import 'package:flutter/material.dart';
import 'package:flutter_mvvm/view_models/movie_detail_controller.dart';
import 'package:get/get.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  const MovieDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Untuk memastikan data detail film diambil saat view dibuat
    // Asumsi: id film harus diambil dari argumen rute atau disuntikkan sebelumnya
    final movieId = Get.arguments as String?; 
    if (movieId != null) {
      // Pastikan data diambil saat view pertama kali di-build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.movieDetail.value == null) {
          controller.fetchDetail(movieId);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Detail Film")),
      body: Obx(() { // Obx mendengarkan variabel reaktif (isLoading, errorMessage, movieDetail)
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final movie = controller.movieDetail.value;
        if (movie == null) {
          // Tampilkan pesan untuk kasus ketika ID tidak valid atau data tidak ada
          return const Center(child: Text("Data tidak ditemukan atau ID rute hilang"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  movie.poster, 
                  height: 300, 
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => const Icon(Icons.broken_image, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("${movie.year} • ${movie.director}", style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 10),
              Chip(label: Text(movie.genre)),
              const SizedBox(height: 20),
              const Text("Plot:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(movie.plot),
            ],
          ),
        );
      }),
    );
  }
}