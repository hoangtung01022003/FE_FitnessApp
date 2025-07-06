import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_text_field.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/register_view_model.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng TextEditingController với hooks để tự động dispose
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Tạo state cho việc hiển thị password
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    // Animation controller cho button loading
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    // Sử dụng ViewModel
    final viewModel = ref.watch(registerViewModelProvider);

    // Thêm các controller từ hook vào view model
    useEffect(() {
      viewModel.setControllers(usernameController, emailController,
          passwordController, confirmPasswordController);
      return null;
    }, []);

    // Hook để animate loading button khi state thay đổi
    useEffect(() {
      if (viewModel.isLoading) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [viewModel.isLoading]);

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderBar(title: 'Register', showBack: true),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: usernameController,
                          hint: 'Username',
                        ),
                        CustomTextField(
                          controller: emailController,
                          hint: 'Email',
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hint: 'Password',
                          obscure: obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                        CustomTextField(
                          controller: confirmPasswordController,
                          hint: 'Confirm Password',
                          obscure: obscureConfirmPassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => obscureConfirmPassword.value =
                                !obscureConfirmPassword.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: CustomButton(
                label: viewModel.isLoading ? 'Loading...' : 'Register',
                onPressed: viewModel.isLoading ? null : viewModel.register,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
