class HourlyForecastEntry {
  const HourlyForecastEntry({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
  });

  final DateTime time;
  final double temperature;
  final int weatherCode;
  final bool isDay;
}
