import 'package:flutter/material.dart';
import 'package:flutter_mvvm/view_models/movie_detail_controller.dart';
import 'package:get/get.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  const MovieDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan informasi ukuran layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final movieId = Get.arguments as String?; 
    if (movieId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.movieDetail.value == null || controller.movieDetail.value?.imdbID != movieId) {
          controller.fetchDetail(movieId);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Film")),
      body: Obx(() {
        if (controller.isLoading.value && controller.movieDetail.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final movie = controller.movieDetail.value;
        if (movie == null) return const Center(child: Text("Data tidak ditemukan"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Layout responsif: Menggunakan Row jika Landscape, Column jika Portrait
              if (isLandscape)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPoster(movie.poster, screenWidth * 0.3), // 30% lebar layar
                    const SizedBox(width: 20),
                    Expanded(child: _buildMainInfo(movie)),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _buildPoster(movie.poster, screenHeight * 0.4)), // 40% tinggi layar
                    const SizedBox(height: 20),
                    _buildMainInfo(movie),
                  ],
                ),

              const SizedBox(height: 20),
              const Text("Plot:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(movie.plot, style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 30),
              const Text("Rekomendasi Film Serupa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              
              // Grid responsif untuk rekomendasi
              _buildResponsiveRecommendations(context, isLandscape),
            ],
          ),
        );
      }),
    );
  }

  // Widget pembantu untuk Poster
  Widget _buildPoster(String url, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
      ),
    );
  }

  // Widget pembantu untuk Info Utama
  Widget _buildMainInfo(dynamic movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text("${movie.year} • ${movie.director}", style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 10),
        Chip(label: Text(movie.genre)),
      ],
    );
  }

  // Widget Daftar Rekomendasi yang menyesuaikan jumlah item per baris
  Widget _buildResponsiveRecommendations(BuildContext context, bool isLandscape) {
    return SizedBox(
      height: 220,
      child: Obx(() {
        if (controller.recommendations.isEmpty) return const Text("Tidak ada rekomendasi.");
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.recommendations.length,
          itemBuilder: (context, index) {
            final rec = controller.recommendations[index];
            return GestureDetector(
              onTap: () => Get.offAndToNamed('/movie-detail', arguments: rec.imdbID),
              child: Container(
                width: isLandscape ? 160 : 130, // Lebih lebar di tablet/landscape
                margin: const EdgeInsets.only(right: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(rec.poster, fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(rec.title, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}