import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/core/themes/app_theme.dart';

class SettingsController extends GetxController {
  
  var isDark = false.obs; 

  @override
  void onInit() {
    isDark.value = Get.isDarkMode;
    super.onInit();
  }

  // --- FUNGSI TOGGLE (Sekali Klik) ---
  void toggleTheme() {
    if (isDark.value) {
      // Jika saat ini gelap, pindah ke terang
      Get.changeTheme(AppTheme.lightTheme);
      Get.changeThemeMode(ThemeMode.light); 
      isDark.value = false;
    } else {
      // Jika saat ini terang, pindah ke gelap
      Get.changeTheme(AppTheme.darkTheme);
      Get.changeThemeMode(ThemeMode.dark); 
      isDark.value = true;
    }
  }

  // setLightMode dan setDarkMode tetap ada untuk halaman Settings (opsional)
  void setLightMode() {
    Get.changeTheme(AppTheme.lightTheme);
    Get.changeThemeMode(ThemeMode.light); 
    isDark.value = false;
  }

  void setDarkMode() {
    Get.changeTheme(AppTheme.darkTheme);
    Get.changeThemeMode(ThemeMode.dark); 
    isDark.value = true;
  }
}