import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherController extends ChangeNotifier {
  final WeatherService service;
  final LocalStorageService storage;

  WeatherController(this.service, this.storage);

  Weather? weather;
  WeatherState state = WeatherState.initial;
  String? errorMessage;

  Future<void> getWeather(String city) async {
    if (city.isEmpty) {
      state = WeatherState.error;
      errorMessage = 'Enter city name';
      notifyListeners();
      return;
    }

    state = WeatherState.loading;
    final cachedWeather = await storage.loadWeather();
    notifyListeners();

    try {
      final newWeather = await service.fetchWeather(city);

      await storage.saveWeather(newWeather);

      weather = newWeather;
      state = WeatherState.loaded;

      notifyListeners();
    } catch (e) {
      errorMessage = 'Loading error';
      state = WeatherState.error;

      notifyListeners();
    }
  }
}
