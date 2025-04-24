import 'package:citi_guide/screens/home_screen.dart';
import 'package:citi_guide/screens/login_screen.dart';
import 'package:citi_guide/screens/profile_screen.dart';
import 'package:citi_guide/services/supabaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void  main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Supabaseservice());
  runApp( CityGuideApp());
}

class ThemeController extends GetxController {
  RxBool mode = false.obs; // false = light, true = dark

  ThemeData get theme => mode.value ? _darkTheme : _lightTheme;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
  
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey[300]),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: IconThemeData(color: Colors.black87),
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey[850]),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white70), 
    ),
    iconTheme: IconThemeData(color: Colors.white70),
  );
}

class CityGuideApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

   CityGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MaterialApp(
          title: 'City Guide',
          theme: themeController.theme,
          initialRoute: '/home',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/profile': (context) => ProfileScreen(),
          },
        ));
  }
}