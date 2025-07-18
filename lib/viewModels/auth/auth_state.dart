import 'package:finess_app/models/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    User? user,
    String? errorMessage,
    String? token,
    @Default(false) bool isRegistering,
    @Default(false)
    bool hasProfile, // Thêm trường này để đánh dấu người dùng đã có profile
  }) = _AuthState;
}
