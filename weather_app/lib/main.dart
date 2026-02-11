import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/weather.dart';

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

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  bool _isLoading = false;
  Weather? _weather;
  String? _error;

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
              onPressed: _getWeather,
              child: const Text('Получить погоду'),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (_weather != null)
              Column(
                children: [
                  Text('City: ${_weather!.cityName}'),
                  Text('Temperature: ${_weather!.temperature} °C'),
                  Text('Description: ${_weather!.description}'),
                  Text('Humidity: ${_weather!.humidity} %'),
                  Text('Wind speed: ${_weather!.windSpeed} mps'),
                ],
              ),
            if (_error != null) Text(_error!),
          ],
        ),
      ),
    );
  }

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      const apiKey = '15c1ac4120a69a1b53eef3653f534f51';

      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?q=$city'
        '&units=metric'
        '&appid=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = Weather.fromJson(data);

        setState(() {
          _weather = weather;
          _error = null;
        });
      } else {
        setState(() {
          _weather = null;
          _error = 'Error. city not found';
        });
      }
    } catch (e) {
      debugPrint('ERROR: $e');
      setState(() {
        _error = 'Network error $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
