import 'package:city_guide/helper/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final _supabase = Supabase.instance.client;
  String _selectedCity = 'Karachi';
  final _cities = ['Lahore', 'Quetta', 'Peshawar', 'Karachi'];
  List<Map<String, dynamic>> _attractions = [];

  @override
  void initState() {
    super.initState();
    _fetchAttractions();

    _supabase.from('attractions').stream(primaryKey: ['id']).listen(
      (List<Map<String, dynamic>> data) {
        setState(() {
          _attractions = data.where((a) => a['city'] == _selectedCity).toList();
        });
      },
      onError: (error) {
      },
    );
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await _supabase
          .from('attractions')
          .select()
          .eq('city', _selectedCity);

      setState(() {
        _attractions = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        _attractions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Guide'),
        actions: [
          Obx(() => themeController.mode.isTrue
              ? IconButton(
                  icon: const Icon(Icons.dark_mode),
                  onPressed: () {
                    themeController.toggleTheme(); // Use toggleTheme to persist
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.light_mode),
                  onPressed: () {
                    themeController.toggleTheme(); // Use toggleTheme to persist
                  },
                )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedCity,
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                  _fetchAttractions();
                });
              },
              items: _cities
                  .map(
                    (city) => DropdownMenuItem(value: city, child: Text(city)),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: _attractions.isEmpty
                ? Center(
                    child: Text(
                      'No attractions found for $_selectedCity.',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _attractions.length,
                    itemBuilder: (context, index) {
                      final attraction = _attractions[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/City', arguments: {
                            'city': _selectedCity,
                            'name': attraction['name'],
                            'description': attraction['description_2'],
                            'image': attraction['image'],
                            'location': attraction['location'],
                          });
                        },
                        child: Card(
                          child: ListTile(
                            leading: Image.network(
                              attraction['image'],
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const CircularProgressIndicator();
                              },
                            ),
                            title: Text(attraction['name']),
                            subtitle: Text(attraction['description']),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}