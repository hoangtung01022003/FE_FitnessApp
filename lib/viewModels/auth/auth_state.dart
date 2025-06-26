import 'package:finess_app/models/user/user.dart';

// AuthState - Lưu trữ trạng thái xác thực
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool hasError;
  final User? user;
  final String? errorMessage;
  final String? token;
  final bool isRegistering;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.hasError = false,
    this.user,
    this.errorMessage,
    this.token,
    this.isRegistering = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? hasError,
    User? user,
    String? errorMessage,
    String? token,
    bool? isRegistering,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }
}
