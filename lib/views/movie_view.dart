import 'package:flutter/material.dart';
import 'package:flutter_mvvm/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter_mvvm/view_models/movie_controller.dart';
// --- Wajib: Import Settings Controller ---
import 'package:flutter_mvvm/view_models/settings_controller.dart'; 
// ----------------------------------------

class MovieView extends GetView<MovieController> {
  final TextEditingController searchController = TextEditingController();

  MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Ambil instance SettingsController yang sudah diinisialisasi
    // Asumsi: SettingsController sudah diinisialisasi di app_pages.dart (Routes.home binding)
    final settingsController = Get.find<SettingsController>(); 

    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Database"),
        actions: [
          // --- TOMBOL TOGGLE TEMA SEKALI KLIK ---
          Obx(() => IconButton(
            // Ganti ikon: Jika Dark, tampilkan LightMode (matahari). Jika Light, tampilkan DarkMode (bulan).
            icon: Icon(
              settingsController.isDark.value 
                ? Icons.light_mode
                : Icons.dark_mode,
            ),
            onPressed: () {
              settingsController.toggleTheme(); // Panggil fungsi toggle
            },
          )),
          // ------------------------------------

          // Tombol Settings (Masih ada, untuk navigasi ke pengaturan lainnya jika perlu)
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(Routes.settings);
            },
          ),
        ],
      ),
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
                    crossAxisCount: 2, 
                    crossAxisSpacing: 12, 
                    mainAxisSpacing: 12, 
                    childAspectRatio: 0.65, 
                  ),
                  itemCount: controller.movieList.length,
                  itemBuilder: (context, index) {
                    final movie = controller.movieList[index];
                    
                    return GestureDetector(
                      onTap: () {
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
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  movie.poster,
                                  fit: BoxFit.cover, 
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
                            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis, 
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