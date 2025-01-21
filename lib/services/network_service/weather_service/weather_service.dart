import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.get("base_url"),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ));
  }

  late final Dio _dio;

  Future<({dynamic data, String? error})> get(
      {required String endpoint}) async {
    try {
      final request = await _dio.get(endpoint);
      final status = request.statusCode ?? 0;
      if (status > 199 && status < 300) {
        return (data: request.data, error: null);
      }
      return (data: null, error: (request.data['message'] ?? "").toString());
    } catch (e) {
      return (data: null, error: e.toString());
    }
  }
}
