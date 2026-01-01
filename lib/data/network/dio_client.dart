import 'package:dio/dio.dart';

class DioClient {
  static Dio create(String baseUrl, String? token) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    return dio;
  }
}
