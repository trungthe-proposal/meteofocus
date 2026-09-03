/// Open-Meteo không cần API key — xem `ARCHITECTURE.md §4`.
abstract final class ApiEndpoints {
  static const owmForecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const owmGeocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
}
