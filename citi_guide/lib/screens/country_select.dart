import 'package:city_guide/screens/home_screen.dart';
import 'package:city_guide/services/supabaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountrySelect extends GetxController {
  var selectedCountry = ''.obs;

  void setSelectedCountry(String? country) {
    selectedCountry.value = country ?? '';
  }
}

class CountrySelectScreen extends StatelessWidget {
  CountrySelectScreen({super.key});

  final CountrySelect controller = Get.put(CountrySelect());

  Future<List<String>> _fetchCountries() async {
    try {
      final response = await Supabaseservice.client
          .from('attractions')
          .select('countries');

      final data = response as List<dynamic>;
      final countries = data
          .map((item) => item['countries'] as String)
          .toSet()
          .toList()
        ..sort();
      return countries;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFFC466B),
                  Color(0xFF3F5EFB),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Text(
              'Welcome to Citiguide',
              style: TextStyle(
                fontFamily: 'myfonts',
                fontStyle: FontStyle.italic,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 180),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<List<String>>(
                    future: _fetchCountries(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No countries available');
                      }

                      final countries = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        hint: Text('Select Country'),
                        value: controller.selectedCountry.value.isEmpty
                            ? null
                            : controller.selectedCountry.value,
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.setSelectedCountry(value);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    return controller.selectedCountry.value.isNotEmpty
                        ? ElevatedButton(
                            onPressed: () {
                              Get.to(() => HomeScreen(), arguments: {
                                'country': controller.selectedCountry.value,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFC466B),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                            child: Text('Go to Cities'),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 