import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/custom_button.dart';
import '../global/header_bar.dart';
import '../global/custom_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi trạng thái xác thực
    final authState = ref.watch(authNotifierProvider);

    // Xử lý trạng thái khi thay đổi
    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, current) {
        // Nếu đang đăng ký và có lỗi
        if (current.isRegistering && current.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(current.errorMessage ?? 'Đăng ký thất bại')),
          );
          // Xóa thông báo lỗi để tránh hiển thị lặp lại
          ref.read(authNotifierProvider.notifier).clearError();
        }

        // Nếu đăng ký thành công
        if (current.isRegistering && current.isAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công')),
          );
          // Quay về màn hình đăng nhập
          Navigator.pop(context);
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBar(title: 'Register', showBack: true),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: usernameController, hint: 'Username'),
                  CustomTextField(controller: emailController, hint: 'Email'),
                  CustomTextField(
                      controller: passwordController,
                      hint: 'Password',
                      obscure: true),
                  CustomTextField(
                      controller: confirmPasswordController,
                      hint: 'Confirm Password',
                      obscure: true),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: CustomButton(
                label: authState.isLoading ? 'Loading...' : 'Register',
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        if (!_validateFields()) {
                          return;
                        }

                        // Gọi register từ authNotifier
                        await ref.read(authNotifierProvider.notifier).register(
                              usernameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text,
                            );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Phương thức để xác thực các trường nhập liệu
  bool _validateFields() {
    // Kiểm tra trường rỗng
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return false;
    }

    // Kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email không đúng định dạng')),
      );
      return false;
    }

    // Kiểm tra mật khẩu khớp nhau
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return false;
    }

    return true;
  }
}
