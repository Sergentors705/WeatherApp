import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'dart:convert';
import 'models/weather.dart';
import 'services/weather_service.dart';
import 'widgets/weather_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '@eather App',
      home: const WeatherScreen(),
    );
  }
}

enum WeatherState { initial, loading, loaded, error }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _localStorageService = LocalStorageService();

  late final WeatherController controller;

  @override
  void initState() {
    super.initState();
    controller = WeatherController(WeatherService(), LocalStorageService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Город',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.getWeather(_cityController.text),
              child: const Text('Получить погоду'),
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                if (controller.state == WeatherState.loading) {
                  return const CircularProgressIndicator();
                }

                if (controller.state == WeatherState.error) {
                  return Text(controller.errorMessage ?? '');
                }

                if (controller.state == WeatherState.loaded &&
                    controller.weather != null) {
                  return WeatherCard(weather: controller.weather!);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
