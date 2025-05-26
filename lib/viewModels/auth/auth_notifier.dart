import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';

// AuthNotifier - Xử lý các logic xác thực
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthNotifier({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState());

  Future<void> login(String email, String password) async {
    // Đặt isLoading = true và xóa lỗi cũ
    state = state.copyWith(
      isLoading: true,
      isRegistering: false,
      hasError: false,
      errorMessage: null,
    );

    try {
      // Gọi repository để thực hiện API call
      final authResponse = await _authRepository.login(email, password);

      // Cập nhật state khi thành công
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true, // Đặt isAuthenticated = true
        user: authResponse.user,
        token: authResponse.token,
        hasError: false,
        errorMessage: null,
      );
    } catch (e) {
      // Chuẩn bị thông báo lỗi chi tiết hơn
      String errorMessage;
      if (e.toString().contains('ERROR[null] => PATH: /login')) {
        errorMessage =
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng!';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Email hoặc mật khẩu không chính xác!';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Tài khoản không tồn tại!';
      } else {
        errorMessage = 'Đã xảy ra lỗi: ${e.toString()}';
      }

      // Cập nhật state khi có lỗi
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        hasError: true,
        errorMessage: errorMessage,
      );
    }
  }

  Future<void> register(String username, String email, String password) async {
    // Đặt isLoading = true và xóa lỗi cũ
    state = state.copyWith(
      isLoading: true,
      isRegistering: true,
      hasError: false,
      errorMessage: null,
    );

    try {
      // Gọi repository để thực hiện API call
      final authResponse =
          await _authRepository.register(username, email, password);

      // Cập nhật state khi thành công
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true, // Đặt isAuthenticated = true
        user: authResponse.user,
        token: authResponse.token,
        hasError: false,
        errorMessage: null,
      );
    } catch (e) {
      // Cập nhật state khi có lỗi
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    if (state.token == null) return;

    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.logout(state.token!);
      state = AuthState(); // Reset về trạng thái ban đầu
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
