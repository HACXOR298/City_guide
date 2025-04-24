import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supabaseservice extends GetxService {
  static final SupabaseClient client = Supabase.instance.client;
  @override
 Future<void> onInit() async {
    await Supabase.initialize(
        url: "https://uotnnufwwxzqfuadmyrt.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvdG5udWZ3d3h6cWZ1YWRteXJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU1MDgwNzEsImV4cCI6MjA2MTA4NDA3MX0.-xGUlvvaYnYO59JkTjS9rLVIIIsWkHR32cLwuwzxbqU");
    super.onInit();
  }
}

