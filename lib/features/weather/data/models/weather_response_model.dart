/// Model thô mirror JSON response Open-Meteo Forecast API — đã đối chiếu thực tế
/// qua `curl https://api.open-meteo.com/v1/forecast?...` (xem `DEVLOG.md` Ngày 2).
class WeatherResponseModel {
  const WeatherResponseModel({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final CurrentBlock current;
  final HourlyBlock hourly;
  final DailyBlock daily;

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      current: CurrentBlock.fromJson(json['current'] as Map<String, dynamic>),
      hourly: HourlyBlock.fromJson(json['hourly'] as Map<String, dynamic>),
      daily: DailyBlock.fromJson(json['daily'] as Map<String, dynamic>),
    );
  }
}

class CurrentBlock {
  const CurrentBlock({
    required this.time,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.isDay,
    required this.weatherCode,
    required this.pressureMsl,
    required this.uvIndex,
    required this.windSpeed10m,
  });

  final DateTime time;
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final bool isDay;
  final int weatherCode;
  final double pressureMsl;
  final double uvIndex;
  final double windSpeed10m;

  factory CurrentBlock.fromJson(Map<String, dynamic> json) => CurrentBlock(
    time: DateTime.parse(json['time'] as String),
    temperature2m: (json['temperature_2m'] as num).toDouble(),
    relativeHumidity2m: (json['relative_humidity_2m'] as num).toInt(),
    apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
    isDay: (json['is_day'] as num).toInt() == 1,
    weatherCode: (json['weather_code'] as num).toInt(),
    pressureMsl: (json['pressure_msl'] as num).toDouble(),
    uvIndex: (json['uv_index'] as num).toDouble(),
    windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
  );
}

class HourlyBlock {
  const HourlyBlock({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
    required this.isDay,
  });

  final List<DateTime> time;
  final List<double> temperature2m;
  final List<int> weatherCode;
  final List<bool> isDay;

  factory HourlyBlock.fromJson(Map<String, dynamic> json) {
    final times = (json['time'] as List).cast<String>();
    final temps = (json['temperature_2m'] as List).cast<num>();
    final codes = (json['weather_code'] as List).cast<num>();
    final days = (json['is_day'] as List).cast<num>();
    return HourlyBlock(
      time: times.map(DateTime.parse).toList(),
      temperature2m: temps.map((e) => e.toDouble()).toList(),
      weatherCode: codes.map((e) => e.toInt()).toList(),
      isDay: days.map((e) => e.toInt() == 1).toList(),
    );
  }
}

class DailyBlock {
  const DailyBlock({
    required this.time,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.uvIndexMax,
  });

  final List<DateTime> time;
  final List<int> weatherCode;
  final List<double> tempMax;
  final List<double> tempMin;
  final List<double> uvIndexMax;

  factory DailyBlock.fromJson(Map<String, dynamic> json) {
    final times = (json['time'] as List).cast<String>();
    final codes = (json['weather_code'] as List).cast<num>();
    final maxT = (json['temperature_2m_max'] as List).cast<num>();
    final minT = (json['temperature_2m_min'] as List).cast<num>();
    final uvi = (json['uv_index_max'] as List).cast<num>();
    return DailyBlock(
      time: times.map(DateTime.parse).toList(),
      weatherCode: codes.map((e) => e.toInt()).toList(),
      tempMax: maxT.map((e) => e.toDouble()).toList(),
      tempMin: minT.map((e) => e.toDouble()).toList(),
      uvIndexMax: uvi.map((e) => e.toDouble()).toList(),
    );
  }
}
