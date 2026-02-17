import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('🌡Temperature: ${weather!.temperature} °C'),
            Text('💧Humidity: ${weather!.humidity} %'),
            Text('🌬Wind speed: ${weather!.windSpeed} mps'),
            const SizedBox(height: 8),
            Text('Description: ${weather!.description}'),
          ],
        ),
      ),
    );
  }
}
