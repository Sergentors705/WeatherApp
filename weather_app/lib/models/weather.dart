class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>?;
    final wind = json['wind'] as Map<String, dynamic>?;

    return Weather(
      cityName: json['name'] ?? '',
      temperature: (main?['temp'] as num)?.toDouble() ?? 0.0,
      description: weatherList != null && weatherList.isNotEmpty
          ? weatherList[0]['description'] ?? ''
          : '',
      humidity: (main?['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind?['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
