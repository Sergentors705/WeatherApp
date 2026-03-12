import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  test("empty city should set error state", () async {
    final controller = WeatherController(
      WeatherRepository(FakeWeatherService(), FakeStorageService()),
    );

    await controller.getWeather("");

    expect(controller.state, WeatherState.error);
  });
  test("successful weather load", () async {
    final controller = WeatherController(
      WeatherRepository(FakeWeatherService(), FakeStorageService()),
    );
    await controller.getWeather("London");

    expect(controller.state, WeatherState.loaded);
    expect(controller.weather, isNotNull);
    expect(controller.weather!.cityName, "London");
    expect(controller.weather!.temperature, 20);
  });

  test("should set error state when service throws exception", () async {
    final controller = WeatherController(
      WeatherRepository(ErrorFakeWeatherService(), FakeStorageService()),
    );
    await controller.getWeather("London");

    expect(controller.state, WeatherState.error);
  });
}
