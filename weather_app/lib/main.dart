import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'services/weather_service.dart';
import 'widgets/weather_card.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherController(
        WeatherRepository(WeatherService(), LocalStorageService()),
      ),
      child: const MyApp(),
    ),
  );
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WeatherController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              onPressed: () {
                context.read<WeatherController>().getWeather(
                  _cityController.text,
                );
              },
              child: const Text('Получить погоду'),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            if (controller.isLoading) const CircularProgressIndicator(),

            if (controller.hasError) Text(controller.errorMessage ?? ''),

            if (controller.hasWeather) WeatherCard(weather: controller.weather),
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
