import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _apiKey = '15c1ac4120a69a1b53eef3653f534f51';

  Future<Weather> fetchWeather(String city) async {
    final encodedCity = Uri.encodeQueryComponent(city);

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?q=$encodedCity'
      '&units=metric'
      '&appid=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('City not found');
    }

    final data = jsonDecode(response.body);
    return Weather.fromJson(data);
  }
}
