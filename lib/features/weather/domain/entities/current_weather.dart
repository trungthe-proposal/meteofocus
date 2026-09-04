class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.pressure,
    required this.uvIndex,
    required this.weatherCode,
    required this.isDay,
    required this.windSpeedKmh,
  });

  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double pressure;
  final double uvIndex;
  final int weatherCode;
  final bool isDay;
  final double windSpeedKmh;
}
