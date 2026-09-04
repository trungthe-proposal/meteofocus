class DailyForecastEntry {
  const DailyForecastEntry({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.uvIndexMax,
  });

  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final double uvIndexMax;
}
