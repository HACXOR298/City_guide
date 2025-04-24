import 'package:citi_guide/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: depend_on_referenced_packages

class HomeScreen extends StatefulWidget {
  @override
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

    _supabase.from('attractions').stream(primaryKey: ['id']).listen((
      List<Map<String, dynamic>> data,
    ) {
      setState(() {
        _attractions = data.where((a) => a['city'] == _selectedCity).toList();
      });
    });
  }

  void _fetchAttractions() async {
    final response = await _supabase
        .from('attractions')
        .select()
        .eq('city', _selectedCity);

    setState(() {
      _attractions = List<Map<String, dynamic>>.from(response ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Guide'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          Obx(() => themeController.mode.isTrue
              ? IconButton(
                  icon: Icon(Icons.dark_mode),
                  onPressed: () {
                    themeController.mode.value = false;
                  },
                )
              : IconButton(
                  icon: Icon(Icons.light_mode),
                  onPressed: () {
                    themeController.mode.value = true;
                  },
                )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
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
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _attractions.length,
                    itemBuilder: (context, index) {
                      final attraction = _attractions[index];
                      return ListTile(
                        leading: attraction['image'] != null &&
                                attraction['image'] != 'null'
                            ? Image.network(
                                attraction['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              )
                            : Icon(Icons.image),
                        title: Text(attraction['name'] ?? 'Unknown'),
                        subtitle:
                            Text(attraction['description'] ?? 'No description'),
                        onTap: () {
                          // TODO: Navigate to detailed view
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}