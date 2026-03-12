import 'package:flutter/foundation.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/weather_repository.dart';

class WeatherController extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherController(this.repository);

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
    final cachedWeather = await repository.getCachedWeather();
    notifyListeners();

    try {
      final newWeather = await repository.getWeather(city);

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
