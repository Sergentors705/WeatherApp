import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather.dart';

class LocalStorageService {
  Future<void> saveWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap = weather.toJson();
    final jsonString = jsonEncode(jsonMap);

    await prefs.setString('last_weather', jsonString);
  }

  Future<Weather?> loadWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('last_weather');

    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final weather = Weather.fromJson(jsonMap);

    return weather;
  }
}
