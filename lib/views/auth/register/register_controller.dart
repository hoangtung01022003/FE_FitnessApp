import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';

/// Controller cho RegisterPage, xử lý tất cả logic liên quan đến đăng ký
class RegisterController {
  final WidgetRef ref;
  final BuildContext context;

  // Controllers cho các trường nhập liệu
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Flag để theo dõi trạng thái lỗi đã xử lý
  bool _errorHandled = false;

  RegisterController(this.ref, this.context);

  // Kiểm tra trạng thái loading
  bool get isLoading => ref.read(authNotifierProvider).isLoading;

  // Xử lý sự kiện đăng ký
  Future<void> handleRegister() async {
    // Kiểm tra trường rỗng
    if (!validateFields()) {
      return;
    }

    // Gọi register từ authNotifier
    await ref.read(authNotifierProvider.notifier).register(
          usernameController.text.trim(),
          emailController.text.trim(),
          passwordController.text,
        );
  }

  // Xử lý sự kiện khi trạng thái xác thực thay đổi
  void listenToAuthChanges(AuthState? previous, AuthState current) {
    // Nếu đang đăng ký và có lỗi
    if (current.isRegistering &&
        current.hasError &&
        current.errorMessage != null &&
        !_errorHandled) {
      _errorHandled = true; // Đánh dấu là đã xử lý lỗi
      showErrorMessage(current.errorMessage!);

      // Sử dụng Future.microtask để tránh thay đổi state trong lúc đang build
      Future.microtask(() {
        ref.read(authNotifierProvider.notifier).clearError();
      });
    } else if (!current.hasError) {
      _errorHandled = false; // Reset flag khi không còn lỗi
    }

    // Nếu đăng ký thành công
    if (current.isRegistering && current.isAuthenticated) {
      showSuccessMessage('Đăng ký thành công');
      // Quay về màn hình đăng nhập
      Navigator.pop(context);
    }
  }

  // Hiển thị thông báo thành công
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Hiển thị thông báo lỗi
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Phương thức để xác thực các trường nhập liệu
  bool validateFields() {
    // Kiểm tra trường rỗng
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorMessage('Vui lòng điền đầy đủ thông tin');
      return false;
    }

    // Kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      showErrorMessage('Email không đúng định dạng');
      return false;
    }

    // Kiểm tra mật khẩu khớp nhau
    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage('Mật khẩu không khớp');
      return false;
    }

    return true;
  }

  // Giải phóng tài nguyên khi không sử dụng nữa
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
