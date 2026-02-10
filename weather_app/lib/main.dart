import 'package:flutter/material.dart';

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
  String? _resultText;

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
            if (_resultText != null) Text(_resultText!),
          ],
        ),
      ),
    );
  }

  Future<void> _getWeather() async {
    final city = _cityController.text;

    setState(() {
      _isLoading = true;
      _resultText = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _resultText = 'Погода для города: $city';
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
