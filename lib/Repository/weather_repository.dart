import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/network_service/weather_service/weather_service.dart';

class WeatherRepository {
  final _apiService = ApiService();

  Future<({WeatherData? model, String? error})> fetchCurrentWeather(
      {double? lat, double? lon}) async {
    final req = await _apiService.get(
        endpoint:
            "?lat=${lat ??5.0377 }&lon=${lon ?? 7.9128 }&appid=${dotenv.get("api_key")}&units=metric");
    if (req.data != null) {
      return (model: WeatherData.fromJson(req.data), error: null);
    } else {
      return (model: null, error: req.error);
    }
  }

  // "6.5244"
  // ?? "3.3792"

  Future<({WeatherData? model, String? error})> fetchCityWeather({
    required String cityName
  })async{
    final request = await _apiService.get(
        endpoint: "?q=$cityName&appid=${dotenv.get("api_key")}&units=metric");
    if(request.data != null){
      return (model: WeatherData.fromJson(request.data), error: null);
    }else{
      return (model: null, error: request.error);
    }
  }
}
