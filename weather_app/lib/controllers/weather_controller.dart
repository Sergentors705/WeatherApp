import 'package:flutter/foundation.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/weather_repository.dart';

class WeatherController extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherController(this.repository);

  Weather? _weather;
  WeatherState _state = WeatherState.initial;
  String? errorMessage;
  String? currentCity;

  bool get isLoading => _state == WeatherState.loading;
  bool get hasError => _state == WeatherState.error;
  bool get hasWeather => _weather != null;
  Weather get weather => _weather!;
  WeatherState get state => _state;

  Future<void> getWeather(String city) async {
    currentCity = city;
    if (city.isEmpty) {
      _state = WeatherState.error;
      errorMessage = 'Enter city name';
      notifyListeners();
      return;
    }

    _state = WeatherState.loading;
    _weather = null;
    notifyListeners();

    try {
      final newWeather = await repository.getWeather(city);

      _weather = newWeather;
      _state = WeatherState.loaded;

      notifyListeners();
    } catch (e) {
      errorMessage = 'Loading error';
      _state = WeatherState.error;

      notifyListeners();
    }
  }
}
