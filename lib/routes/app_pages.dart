import 'package:flutter_mvvm/data/repositories/movie_repository.dart';
import 'package:flutter_mvvm/data/services/omdb_services.dart';
import 'package:flutter_mvvm/view_models/movie_controller.dart';
import 'package:flutter_mvvm/view_models/movie_detail_controller.dart';
import 'package:flutter_mvvm/views/movie_detail_view.dart';
import 'package:get/get.dart';
import 'package:flutter_mvvm/views/movie_view.dart';
import 'package:flutter_mvvm/routes/app_routes.dart'; 

class AppPages {
  
  static final routes = [ 
    GetPage(
      name: Routes.home,
      page: () => MovieView(),
      binding: BindingsBuilder(() {
        // Services (Di-inject agar bisa diakses oleh rute lain)
        Get.lazyPut(() => OmdbServices());

        // Repositories (Di-inject agar bisa diakses oleh rute lain)
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
      }),
    ), // Perbaikan: Tambahkan koma di sini

    // Perbaikan: Ganti { menjadi GetPage( dan sintaks lainnya
    GetPage(
      name: Routes.detail, // Asumsi Anda menggunakan konvensi huruf kapital untuk konstanta
      page: () => MovieDetailView(),
      binding: BindingsBuilder(() {
        // MovieDetailController hanya perlu MovieRepository yang sudah di-inject di atas
        Get.lazyPut(
          () => MovieDetailController(
            // Perbaikan: Sintaks Get.find yang benar
            repository: Get.find<MovieRepository>(),
          ),
        );
      }),
    ),
  ];
}