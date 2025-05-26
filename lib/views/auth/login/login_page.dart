import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_text_field.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/login_view_model.dart';
import 'package:finess_app/views/auth/register/register_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng ViewModel
    final viewModel = ref.watch(loginViewModelProvider);

    // Hiển thị thông báo lỗi
    void showErrorMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    // Hiển thị thông báo thành công
    void showSuccessMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    // Lắng nghe sự thay đổi trạng thái xác thực
    ref.listen<AuthState>(
      viewModel.authProvider,
      (prev, current) => viewModel.handleAuthChanges(
        context,
        prev,
        current,
        showErrorMessage,
        showSuccessMessage,
      ),
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
                  CustomTextField(
                      controller: viewModel.emailController, hint: 'Email'),
                  CustomTextField(
                      controller: viewModel.passwordController,
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
                label: viewModel.isLoading ? 'Loading...' : 'Sign in',
                onPressed: viewModel.isLoading ? null : viewModel.login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
