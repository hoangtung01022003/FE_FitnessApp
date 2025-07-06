// Provider cho repository xác thực
import 'package:dio/dio.dart';
import 'package:finess_app/global/dio_client.dart';
import 'package:finess_app/models/user/user.dart';
import 'package:finess_app/repositories/auth/auth_repository.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';
import 'package:finess_app/services/storage/auth_storage_provider.dart';
import 'package:finess_app/viewModels/auth/auth_notifier.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart' show AuthState;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

// Provider - Cung cấp truy cập tới state và notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final authStorage = ref.watch(authStorageProvider);
  return AuthNotifier(
    authRepository: repository,
    authStorage: authStorage,
  );
});

// Provider tiện ích để truy cập token dễ dàng
final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).token;
});

// Provider tiện ích để truy cập user đã xác thực
final authenticatedUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

// Provider để kiểm tra xem người dùng đã hoàn thành onboarding chưa
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  return ref.watch(authNotifierProvider.notifier).hasCompletedOnboarding();
});

// Provider cho Dio có xác thực
final authenticatedDioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authTokenProvider);
  return ref.watch(authedDioProvider(token));
});
