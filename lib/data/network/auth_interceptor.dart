import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show VoidCallback;
import '../datasources/local/auth_local_ds.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource local;
  final VoidCallback onUnauthorized;

  AuthInterceptor({
    required this.local,
    required this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await local.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response?.statusCode == 401) {
      onUnauthorized();
    }
    super.onError(err, handler);
  }
}

