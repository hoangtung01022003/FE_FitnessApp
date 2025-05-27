import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/auth_notifier.dart';
import 'package:finess_app/views/auth/welcome/welcome.dart';

// Provider cho RegisterViewModel
final registerViewModelProvider =
    Provider.autoDispose<RegisterViewModel>((ref) {
  return RegisterViewModel(ref);
});

class RegisterViewModel {
  final Ref ref;

  // Controllers cho các trường nhập liệu
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Flag để theo dõi trạng thái lỗi đã xử lý
  bool _errorHandled = false;
  // Flag để theo dõi trạng thái chuyển hướng đã xử lý
  bool _navigationHandled = false;

  RegisterViewModel(this.ref);

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

    // Gọi register từ authNotifier
    await ref.read(authNotifierProvider.notifier).register(
          usernameController.text.trim(),
          emailController.text.trim(),
          passwordController.text,
        );
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Welcome()),
        );
      });
    }
  }

  // Giải phóng tài nguyên khi không sử dụng nữa
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
