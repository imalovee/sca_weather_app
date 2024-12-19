import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/network_service/weather_service/weather_service.dart';

class WeatherRepository {
  final _apiService = ApiService();

  Future<({WeatherData? model, String? error})> fetchCurrentWeather() async {
    final req = await _apiService.get(
        endpoint:
            "?lat=6.5244&lon=3.3792&appid=aebceb2a4b45c888523b22c4d436c5b3&units=metric");
    if (req.data != null) {
      return (model: WeatherData.fromJson(req.data), error: null);
    } else {
      return (model: null, error: req.error);
    }
  }
}
