import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/routes/router.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/auth_notifier.dart';

// Provider cho LoginViewModel
final loginViewModelProvider = Provider.autoDispose<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel {
  final Ref ref;

  // Controllers cho các trường nhập liệu
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Flag để theo dõi trạng thái lỗi đã xử lý
  bool _errorHandled = false;
  // Flag để theo dõi trạng thái chuyển hướng đã xử lý
  bool _navigationHandled = false;

  LoginViewModel(this.ref);

  // Phương thức mới để cập nhật controllers từ hooks
  void setControllers(
      TextEditingController email, TextEditingController password) {
    emailController = email;
    passwordController = password;
  }

  // Kiểm tra trạng thái loading
  bool get isLoading => ref.read(authNotifierProvider).isLoading;

  // Lấy authNotifierProvider từ auth_providers.dart để lắng nghe thay đổi
  StateNotifierProvider<AuthNotifier, AuthState> get authProvider =>
      authNotifierProvider;

  // Phương thức để xác thực các trường nhập liệu
  bool validateFields() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }

    // Kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      return false;
    }

    return true;
  }

  // Xử lý sự kiện đăng nhập
  Future<void> login() async {
    if (!validateFields()) {
      return;
    }

    // Reset flag chuyển hướng khi thực hiện đăng nhập mới
    _navigationHandled = false;
    _errorHandled = false;

    try {
      // Gọi login từ authNotifier
      await ref.read(authNotifierProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text,
          );
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error during login: $e');
    }
  }

  // Xử lý sự kiện khi trạng thái xác thực thay đổi
  void handleAuthChanges(BuildContext context, AuthState? previous,
      AuthState current, Function(String) onError, Function(String) onSuccess) {
    // Nếu đang đăng nhập và có lỗi
    if (!current.isRegistering &&
        current.hasError &&
        current.errorMessage != null &&
        !_errorHandled) {
      _errorHandled = true; // Đánh dấu là đã xử lý lỗi
      onError(current.errorMessage!);

      // Hiển thị thông tin chi tiết về lỗi cho việc debug
      print('Auth Error: ${current.errorMessage}');

      // Sử dụng Future.microtask để tránh thay đổi state trong lúc đang build
      Future.microtask(() {
        ref.read(authNotifierProvider.notifier).clearError();
      });
    } else if (!current.hasError) {
      _errorHandled = false; // Reset flag khi không còn lỗi
    }

    // Nếu đăng nhập thành công và chưa chuyển hướng
    if (current.isAuthenticated && !_navigationHandled) {
      _navigationHandled = true; // Đánh dấu đã xử lý chuyển hướng
      onSuccess('Đăng nhập thành công');

      // Sử dụng Future.microtask để tránh thay đổi state trong lúc đang build
      Future.microtask(() async {
        // Kiểm tra xem người dùng đã hoàn thành onboarding chưa
        final hasCompletedOnboarding = await ref
            .read(authNotifierProvider.notifier)
            .hasCompletedOnboarding();

        // Kiểm tra xem người dùng đã có profile chưa
        final hasProfile = current.hasProfile;

        if (!hasCompletedOnboarding) {
          // Nếu chưa hoàn thành onboarding, chuyển đến welcome page
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.welcome,
              (route) => false, // Xóa tất cả màn hình trước đó
            );
          }
        } else if (!hasProfile) {
          // Nếu đã onboarding nhưng chưa có profile, chuyển đến trang step1
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.welcome,
              (route) => false, // Xóa tất cả màn hình trước đó
            );
          }
        } else {
          // Nếu đã hoàn thành onboarding và có profile, chuyển đến màn hình chính
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.home,
              (route) => false,
            );
          }
        }
      });
    }
  }

  // Không cần gọi dispose nữa vì controllers được quản lý bởi hooks
}
