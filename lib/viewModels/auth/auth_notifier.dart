import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/models/user/user.dart';
import 'package:finess_app/repositories/auth/auth_repository_interface.dart';
import 'package:finess_app/services/storage/auth_storage_service.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';

// AuthNotifier - Xử lý các logic xác thực
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;
  final AuthStorageService _authStorage;

  AuthNotifier({
    required IAuthRepository authRepository,
    required AuthStorageService authStorage,
  })  : _authRepository = authRepository,
        _authStorage = authStorage,
        super(AuthState());

  // Khởi tạo trạng thái ban đầu từ storage
  Future<void> initializeAuthState() async {
    try {
      final isLoggedIn = await _authStorage.isLoggedIn();
      if (isLoggedIn) {
        final token = await _authStorage.getAuthToken();
        final userId = await _authStorage.getUserId();
        final email = await _authStorage.getUserEmail();
        final username = await _authStorage.getUserName();

        if (token != null && userId != null) {
          state = state.copyWith(
            isAuthenticated: true,
            token: token,
            user: email != null
                ? User(
                    id: userId.toString(), // Chuyển từ int sang String
                    username: username ?? '', // Sử dụng username thay vì name
                    email: email,
                  )
                : null,
          );
        }
      }
    } catch (e) {
      // Nếu có lỗi, đặt lại trạng thái
      state = AuthState();
    }
  }

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

      // Lưu thông tin đăng nhập vào storage
      await _authStorage.saveAuthInfo(
        token: authResponse.token,
        userId: int.tryParse(authResponse.user.id) ??
            0, // Chuyển từ String sang int
        email: authResponse.user.email,
        name: authResponse.user.username, // Sử dụng username thay vì name
      );

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

      // Lưu thông tin đăng nhập vào storage
      await _authStorage.saveAuthInfo(
        token: authResponse.token,
        userId: int.tryParse(authResponse.user.id) ??
            0, // Chuyển từ String sang int
        email: authResponse.user.email,
        name: authResponse.user.username, // Sử dụng username thay vì name
      );

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

  // Đánh dấu đã hoàn thành onboarding
  Future<void> completeOnboarding() async {
    await _authStorage.setOnboardingCompleted(true);
  }

  // Kiểm tra đã hoàn thành onboarding chưa
  Future<bool> hasCompletedOnboarding() async {
    return _authStorage.hasCompletedOnboarding();
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      if (state.token != null) {
        await _authRepository.logout(state.token!);
      }

      // Xóa thông tin đăng nhập từ storage
      await _authStorage.logout();

      // Reset về trạng thái ban đầu
      state = AuthState();
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
