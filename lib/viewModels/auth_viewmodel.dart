import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:finess_app/global/dio_client.dart';
import 'package:finess_app/models/user.dart';
import 'package:finess_app/viewModels/auth_state.dart';

class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isNotEmpty(String text) {
    return text.trim().isNotEmpty;
  }

  static bool passwordsMatch(String pass1, String pass2) {
    return pass1 == pass2;
  }
}

// Repository provider cho các API call liên quan đến authentication
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio);
});

// Notifier provider cho quản lý state của authentication
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: authRepository);
});

// Repository class để thực hiện các API call
class AuthRepository {
  final Dio dio;

  AuthRepository({required this.dio});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Đăng nhập thất bại');
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await dio.post('/api/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Đăng ký thất bại');
    }
  }

  Future<void> logout(String token) async {
    try {
      await dio.post('/api/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Đăng xuất thất bại');
    }
  }
}

// Notifier class để quản lý logic và state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await authRepository.login(email, password);
      final user = User.fromMap(response['user']);
      final token = response['token'];

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await authRepository.register(name, email, password);
      final user = User.fromMap(response['user']);
      final token = response['token'];

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    if (state.token == null) return;

    state = state.copyWith(status: AuthStatus.loading);

    try {
      await authRepository.logout(state.token!);
      state = AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
