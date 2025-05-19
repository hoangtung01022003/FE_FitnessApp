import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthNotifier({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isRegistering: false,
      errorMessage: null,
    );

    try {
      final authResponse = await _authRepository.login(email, password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        token: authResponse.token,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.loading, 
      isRegistering: true,
      errorMessage: null,
    );

    try {
      final authResponse = await _authRepository.register(username, email, password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        token: authResponse.token,
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
      await _authRepository.logout(state.token!);
      state = AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}