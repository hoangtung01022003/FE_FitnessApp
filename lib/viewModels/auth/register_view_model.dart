import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/routes/router.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/auth_notifier.dart';

// Provider cho RegisterViewModel
final registerViewModelProvider =
    Provider.autoDispose<RegisterViewModel>((ref) {
  return RegisterViewModel(ref);
});

class RegisterViewModel {
  final Ref ref;

  // Controllers cho các trường nhập liệu
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Flag để theo dõi trạng thái lỗi đã xử lý
  bool _errorHandled = false;
  // Flag để theo dõi trạng thái chuyển hướng đã xử lý
  bool _navigationHandled = false;

  RegisterViewModel(this.ref);

  // Phương thức mới để cập nhật controllers từ hooks
  void setControllers(
    TextEditingController username,
    TextEditingController email,
    TextEditingController password,
    TextEditingController confirmPassword,
  ) {
    usernameController = username;
    emailController = email;
    passwordController = password;
    confirmPasswordController = confirmPassword;
  }

  // Kiểm tra trạng thái loading
  bool get isLoading => ref.read(authNotifierProvider).isLoading;

  // Lấy authNotifierProvider từ auth_providers.dart để lắng nghe thay đổi
  StateNotifierProvider<AuthNotifier, AuthState> get authProvider =>
      authNotifierProvider;

  // Phương thức để xác thực các trường nhập liệu
  bool validateFields() {
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return false;
    }

    // Kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      return false;
    }

    // Kiểm tra mật khẩu khớp nhau
    if (passwordController.text != confirmPasswordController.text) {
      return false;
    }

    return true;
  }

  // Xử lý sự kiện đăng ký
  Future<void> register() async {
    if (!validateFields()) {
      return;
    }

    // Reset flag chuyển hướng khi thực hiện đăng ký mới
    _navigationHandled = false;
    _errorHandled = false;

    // Gọi register từ authNotifier
    try {
      await ref.read(authNotifierProvider.notifier).register(
            usernameController.text.trim(),
            emailController.text.trim(),
            passwordController.text,
          );
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error during registration: $e');
    }
  }

  // Xử lý sự kiện khi trạng thái xác thực thay đổi
  void handleAuthChanges(BuildContext context, AuthState? previous,
      AuthState current, Function(String) onError, Function(String) onSuccess) {
    // Nếu đang đăng ký và có lỗi
    if (current.isRegistering &&
        current.hasError &&
        current.errorMessage != null &&
        !_errorHandled) {
      _errorHandled = true; // Đánh dấu là đã xử lý lỗi
      onError(current.errorMessage!);

      // Sử dụng Future.microtask để tránh thay đổi state trong lúc đang build
      Future.microtask(() {
        ref.read(authNotifierProvider.notifier).clearError();
      });
    } else if (!current.hasError) {
      _errorHandled = false; // Reset flag khi không còn lỗi
    }

    // Nếu đăng ký thành công và đã xác thực và chưa chuyển hướng
    if (current.isAuthenticated && !_navigationHandled) {
      _navigationHandled = true; // Đánh dấu đã xử lý chuyển hướng
      onSuccess('Đăng ký thành công');

      // Sử dụng Future.microtask để tránh thay đổi state trong lúc đang build
      Future.microtask(() {
        // Người dùng mới đăng ký luôn cần đi qua màn hình onboarding
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.welcome,
            (route) => false, // Xóa tất cả màn hình trước đó
          );
        }
      });
    }
  }

  // Không cần gọi dispose nữa vì controllers được quản lý bởi hooks
}
