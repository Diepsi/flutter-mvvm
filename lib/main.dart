import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart'; // Perbaikan: Menggunakan import standar GetX
// Tambahan Wajib: Import file routing
import 'package:flutter_mvvm/routes/app_pages.dart'; 
import 'package:flutter_mvvm/routes/app_routes.dart'; 

// Import file tema yang baru
import 'package:flutter_mvvm/core/themes/app_theme.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      // --- KONFIGURASI TEMA UNTUK DARK/LIGHT MODE ---
      theme: AppTheme.lightTheme,    // Tema default (mode terang)
      darkTheme: AppTheme.darkTheme,  // Tema untuk mode gelap
      themeMode: ThemeMode.system,    // Mengikuti pengaturan tema OS/perangkat
      // ----------------------------------------------
      
      initialRoute: Routes.home, 
      getPages: AppPages.routes, 
    );
  }
}