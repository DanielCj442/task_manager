import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:3000'),
  );

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return {
      'id': response.data['user']['id'],
      'email': response.data['user']['email'],
      'token': response.data['token'],
    };
  }
}
