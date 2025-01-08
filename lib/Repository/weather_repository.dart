import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/network_service/weather_service/weather_service.dart';

class WeatherRepository {
  final _apiService = ApiService();

  Future<({WeatherData? model, String? error})> fetchCurrentWeather(
      {double? lat, double? lon}) async {
    final req = await _apiService.get(
        endpoint:
            "?lat=${lat ?? "6.5244"}&lon=${lon ?? "3.3792"}&appid=${dotenv.get("api_key")}&units=metric");
    if (req.data != null) {
      return (model: WeatherData.fromJson(req.data), error: null);
    } else {
      return (model: null, error: req.error);
    }
  }
}
