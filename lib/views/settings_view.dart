import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mvvm/view_models/settings_controller.dart'; 

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ganti GetView<T> dengan GetBuilder<T> atau bungkus body dengan Obx
    // Agar lebih sederhana, kita gunakan Obx yang membungkus seluruh body
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
      ),
      // Obx wajib untuk mengamati perubahan controller.isDark.value
      body: Obx(() => ListView( 
        children: [
          // Mode Terang
          RadioListTile<bool>(
            secondary: const Icon(Icons.wb_sunny), 
            title: const Text('Light Mode'),
            value: false, 
            groupValue: controller.isDark.value, // Mengakses .value dari RxBool
            onChanged: (val) {
              if (val == false) {
                controller.setLightMode();
              }
            },
          ),
          
          const Divider(),
          
          // Mode Gelap
          RadioListTile<bool>(
            secondary: const Icon(Icons.brightness_2), 
            title: const Text('Dark Mode'),
            value: true, 
            groupValue: controller.isDark.value, // Mengakses .value dari RxBool
            onChanged: (val) {
              if (val == true) {
                controller.setDarkMode();
              }
            },
          ),
          
          const Divider(),
        ],
      )),
    );
  }
}