import 'package:finess_app/models/user/user.dart';

class AuthResponse {
  final String message;
  final User user;
  final String token;

  AuthResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      message: map['message'] ?? '',
      user: User.fromMap(map['user']),
      token: map['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'user': user.toMap(),
      'token': token,
    };
  }
}
