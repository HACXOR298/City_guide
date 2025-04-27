import 'package:city_guide/helper/theme_controller.dart';
import 'package:city_guide/screens/city_desc.dart';
import 'package:city_guide/screens/home_screen.dart';
import 'package:city_guide/services/supabaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabaseservice().onInit();
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'City Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Define your light theme
      darkTheme: ThemeData.dark(), // Define your dark theme
      themeMode: ThemeMode.system, // Will be controlled by ThemeController
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),

        GetPage(name: '/City', page: () => CityDesc()),
      ],
    );
  }
}