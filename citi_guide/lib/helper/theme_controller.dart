import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Reactive boolean to track theme mode (true for dark, false for light)
  var mode = false.obs;

  // Key for storing theme mode in SharedPreferences
  static const String _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    // Load theme mode when the controller initializes
    _loadThemeMode();
  }

  // Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to false (light mode) if no value is found
    mode.value = prefs.getBool(_themeKey) ?? false;
    // Apply the loaded theme to the app
    _updateTheme();
  }

  // Save theme mode to SharedPreferences and update the app theme
  void toggleTheme() async {
    mode.value = !mode.value; // Toggle the mode
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, mode.value); // Save to storage
    _updateTheme();
  }

  // Update the app's theme based on the mode value
  void _updateTheme() {
    Get.changeThemeMode(mode.value ? ThemeMode.dark : ThemeMode.light);
  }
}