import 'package:flutter/material.dart';
import 'package:flutter_mvvm/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter_mvvm/view_models/movie_controller.dart';

class MovieView extends GetView<MovieController> {
  final TextEditingController searchController = TextEditingController();

  MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Database")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian Search Box (Tetap Sama)
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari Film...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    controller.searchMovies(searchController.text);
                    FocusScope.of(context).unfocus();
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              onSubmitted: (val) => controller.searchMovies(val),
            ),
            SizedBox(height: 16),

            // Bagian Result (Grid View)
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }
                if (controller.movieList.isEmpty) {
                  return Center(child: Text("Data kosong, silakan cari film."));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom (2 kolom ke samping)
                    crossAxisSpacing: 12, // Jarak horizontal antar item
                    mainAxisSpacing: 12, // Jarak vertikal antar item
                    childAspectRatio: 0.65, // Rasio tinggi:lebar (makin kecil makin tinggi card-nya)
                  ),
                  itemCount: controller.movieList.length,
                  itemBuilder: (context, index) {
                    final movie = controller.movieList[index];
                    
                    return GestureDetector(
                      onTap: () {
                        // Navigasi ke Detail
                        Get.toNamed(Routes.detail, arguments: movie.imdbID);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Bagian Gambar (Expanded agar mengisi sisa ruang atas)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  movie.poster,
                                  fit: BoxFit.cover, // Gambar full memenuhi area
                                  errorBuilder: (ctx, error, stack) => Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                  loadingBuilder: (ctx, child, progress) {
                                    if (progress == null) return child;
                                    return Center(child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                            
                            // 2. Bagian Teks (Judul & Tahun)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 2, // Maksimal 2 baris
                                    overflow: TextOverflow.ellipsis, // ... jika kepanjangan
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    movie.year,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}