import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/base_url_provider.dart';

// Interceptor to log requests & responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // print(
    //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

// Auth interceptor to add token to requests
class AuthInterceptor extends Interceptor {
  final String? token;

  AuthInterceptor(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

// Dio provider without auth
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30), // Tăng từ 5s lên 30s
    receiveTimeout: const Duration(seconds: 30), // Tăng từ 3s lên 30s
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));

  dio.interceptors.addAll([
    LoggingInterceptor(),
  ]);

  return dio;
});

// Dio provider with auth token
final authedDioProvider = Provider.family<Dio, String?>((ref, token) {
  final dio = ref.watch(dioProvider);

  // Clone to avoid modifying the original instance
  final authedDio = Dio(dio.options);

  // Add all original interceptors
  authedDio.interceptors.addAll(dio.interceptors);

  // Add auth interceptor if token is provided
  if (token != null) {
    authedDio.interceptors.add(AuthInterceptor(token));
  }

  return authedDio;
});
