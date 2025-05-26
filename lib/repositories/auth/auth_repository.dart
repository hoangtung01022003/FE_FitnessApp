import 'package:dio/dio.dart';
import 'package:finess_app/models/api/auth_response.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponse.fromMap(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> register(
      String username, String email, String password) async {
    try {
      // Đảm bảo password có độ dài tối thiểu 8 ký tự theo yêu cầu backend
      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters long');
      }
      final response = await _dio.post(
        '/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return AuthResponse.fromMap(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await _dio.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      // The server responded with an error status code
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('error')) {
          return Exception(data['error']);
        }
        if (data.containsKey('message')) {
          return Exception(data['message']);
        }
      }
    }
    return Exception('Có lỗi xảy ra: ${e.message}');
  }
}
