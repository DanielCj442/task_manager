import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

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
