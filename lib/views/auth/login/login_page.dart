import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_text_field.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/views/auth/login/login_controller.dart';
import 'package:finess_app/views/auth/register/register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(ref, context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi trạng thái xác thực
    final authState = ref.watch(authNotifierProvider);

    // Xử lý trạng thái khi thay đổi
    ref.listen<AuthState>(
      authNotifierProvider,
      _controller.listenToAuthChanges,
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
                      controller: _controller.emailController, hint: 'Email'),
                  CustomTextField(
                      controller: _controller.passwordController,
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
                onPressed: authState.isLoading ? null : _controller.handleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
