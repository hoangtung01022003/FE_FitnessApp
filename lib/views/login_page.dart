import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/custom_button.dart';
import '../global/header_bar.dart';
import 'register_page.dart';
import '../global/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
        // Nếu đang đăng nhập và có lỗi
        if (!current.isRegistering && current.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(current.errorMessage ?? 'Đăng nhập thất bại')),
          );
          // Xóa thông báo lỗi để tránh hiển thị lặp lại
          ref.read(authNotifierProvider.notifier).clearError();
        }

        // Nếu đăng nhập thành công
        if (current.isAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công')),
          );
          // Điều hướng đến trang chính ở đây (nếu cần)
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage()));
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
                  const HeaderBar(title: 'Sign in'),
                  const SizedBox(height: 20),
                  CustomTextField(controller: emailController, hint: 'Email'),
                  CustomTextField(
                      controller: passwordController,
                      hint: 'Password',
                      obscure: true),
                ],
              ),
            ),
            Positioned(
              bottom: 110,
              left: 16,
              right: 16,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: CustomButton(
                label: authState.isLoading ? 'Loading...' : 'Sign in',
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        // Kiểm tra trường rỗng
                        if (!_validateFields()) {
                          return;
                        }

                        // Gọi login từ authNotifier
                        await ref.read(authNotifierProvider.notifier).login(
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
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
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

    return true;
  }
}
