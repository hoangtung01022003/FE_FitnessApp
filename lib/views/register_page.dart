import 'package:finess_app/viewModels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/custom_button.dart';
import '../global/header_bar.dart';
import '../global/custom_text_field.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
                  CustomTextField(controller: usernameController, hint: 'Username'),
                  CustomTextField(controller: emailController, hint: 'Email'),
                  CustomTextField(controller: passwordController, hint: 'Password', obscure: true),
                  CustomTextField(controller: confirmPasswordController, hint: 'Confirm Password', obscure: true),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: CustomButton(
                label: 'Register',
                onPressed: () {
                  if (Validators.isNotEmpty(usernameController.text) || Validators.isNotEmpty(emailController.text) || Validators.isNotEmpty(passwordController.text) || !Validators.isNotEmpty(confirmPasswordController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required')),
                    );
                    return;
                  }
                  if (!Validators.isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email format')),
                    );
                    return;
                  }
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
