import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherRepository {
  final WeatherService service;
  final LocalStorageService storage;

  WeatherRepository(this.service, this.storage);

  Future<Weather> getWeather(String city) async {
    final weather = await service.fetchWeather(city);
    await storage.saveWeather(weather);
    return weather;
  }

  Future<Weather?> getCachedWeather() {
    return storage.loadWeather();
  }
}
