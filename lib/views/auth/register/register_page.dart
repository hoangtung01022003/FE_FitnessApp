import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_text_field.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/views/auth/register/register_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(ref, context);
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
                  const HeaderBar(title: 'Register', showBack: true),
                  const SizedBox(height: 20),
                  CustomTextField(controller: _controller.usernameController, hint: 'Username'),
                  CustomTextField(controller: _controller.emailController, hint: 'Email'),
                  CustomTextField(controller: _controller.passwordController, hint: 'Password', obscure: true),
                  CustomTextField(controller: _controller.confirmPasswordController, hint: 'Confirm Password', obscure: true),
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
                    : _controller.handleRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}