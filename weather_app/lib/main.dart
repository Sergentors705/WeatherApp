import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  WeatherState _state = WeatherState.initial;
  Weather? _weather;
  String? _errorMessage;

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
              onPressed: _state == WeatherState.loading ? null : _getWeather,
              child: const Text('Получить погоду'),
            ),
            const SizedBox(height: 24),
            if (_state == WeatherState.loading)
              const CircularProgressIndicator(),
            if (_state == WeatherState.error) Text(_errorMessage ?? ''),
            if (_state == WeatherState.loaded && _weather != null)
              WeatherCard(weather: _weather!),
          ],
        ),
      ),
    );
  }

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _state = WeatherState.error;
        _errorMessage = 'Enter city name';
      });
      return;
    }

    setState(() {
      _state = WeatherState.loading;
    });

    try {
      final weather = await _weatherService.fetchWeather(city);

      setState(() {
        _weather = weather;
        _state = WeatherState.loaded;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Loading error';
        _state = WeatherState.error;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
