import 'package:finess_app/models/user.dart';

enum AuthStatus { initial, loading, authenticated, error, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? token;
  final bool isRegistering;

  AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.token,
    this.isRegistering = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? token,
    bool? isRegistering,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}