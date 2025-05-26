import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/dio_client.dart';
import 'package:finess_app/models/user.dart';
import 'package:finess_app/repositories/auth/auth_repository.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';
import 'package:finess_app/viewModels/auth/auth_notifier.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';

// Provider cho repository xác thực
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

// Provider - Cung cấp truy cập tới state và notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: repository);
});

// Provider tiện ích để truy cập token dễ dàng
final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).token;
});

// Provider tiện ích để truy cập user đã xác thực
final authenticatedUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

// Provider cho Dio có xác thực
final authenticatedDioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authTokenProvider);
  return ref.watch(authedDioProvider(token));
});
