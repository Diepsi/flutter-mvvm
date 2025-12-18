import 'package:flutter_mvvm/data/repositories/movie_repository.dart';
import 'package:flutter_mvvm/data/services/omdb_services.dart';
import 'package:flutter_mvvm/view_models/movie_controller.dart';
import 'package:flutter_mvvm/view_models/movie_detail_controller.dart';
import 'package:flutter_mvvm/views/movie_detail_view.dart';
import 'package:get/get.dart';
import 'package:flutter_mvvm/views/movie_view.dart';
import 'package:flutter_mvvm/routes/app_routes.dart'; 
// Tambah Import
import 'package:flutter_mvvm/views/settings_view.dart'; 
import 'package:flutter_mvvm/view_models/settings_controller.dart'; 

class AppPages {
  
  static final routes = [ 
    GetPage(
      name: Routes.home,
      page: () => MovieView(),
      binding: BindingsBuilder(() {
        // Services/Repositories lama...
        Get.lazyPut(() => OmdbServices());
        Get.lazyPut(
          () => MovieRepository(
            omdbService: Get.find<OmdbServices>(),
          ),
        );
        
        // Controllers untuk Home View
        Get.lazyPut(
          () => MovieController(
            repository: Get.find<MovieRepository>(),
          ),
        );
        
        // --- FIX: Inisialisasi SettingsController di sini agar selalu siap di MovieView ---
        Get.lazyPut<SettingsController>(
          () => SettingsController(),
        );
        // --------------------------------------------------------------------------------
      }),
    ), 

    GetPage(
      name: Routes.detail, 
      page: () => MovieDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
          () => MovieDetailController(
            repository: Get.find<MovieRepository>(),
          ),
        );
      }),
    ),
    
    // --- Rute Settings: Tidak perlu inisialisasi lagi, cukup panggil instance yang sudah ada ---
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(), 
      binding: BindingsBuilder(() {}), // Binding kosong
    ),
  ];
}