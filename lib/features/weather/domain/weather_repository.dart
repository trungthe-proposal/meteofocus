import '../../location/domain/entities/city.dart';
import 'entities/weather_snapshot.dart';

abstract interface class WeatherRepository {
  Future<WeatherSnapshot> getWeather(City city);
}
