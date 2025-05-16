import 'package:finess_app/viewModels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/custom_button.dart';
import '../global/header_bar.dart';
import 'register_page.dart';
import '../global/custom_text_field.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
                label: 'Sign in',
                onPressed: () async {
                  if (Validators.isNotEmpty(emailController.text) || Validators.isNotEmpty(passwordController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required')),
                    );
                    return;
                  }
                  if (Validators.isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email format')),
                    );
                    return;
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
