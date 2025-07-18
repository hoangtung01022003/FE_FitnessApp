import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_text_field.dart';
import 'package:finess_app/viewModels/auth/auth_state.dart';
import 'package:finess_app/viewModels/auth/login_view_model.dart';
import 'package:finess_app/views/auth/register/register_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng TextEditingController với hooks để tự động dispose
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // Tạo state cho việc hiển thị password
    final obscurePassword = useState(true);

    // Animation controller cho button loading
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    // Sử dụng ViewModel
    final viewModel = ref.watch(loginViewModelProvider);

    // Thêm các controller từ hook vào view model
    useEffect(() {
      viewModel.setControllers(emailController, passwordController);
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderBar(title: 'Login', showBack: true),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  hint: 'Email',
                  enabled:
                      !viewModel.isLoading, // Vô hiệu hóa input khi loading
                ),
                CustomTextField(
                  controller: passwordController,
                  hint: 'Password',
                  obscure: obscurePassword.value,
                  enabled:
                      !viewModel.isLoading, // Vô hiệu hóa input khi loading
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: viewModel.isLoading
                        ? null // Vô hiệu hóa khi loading
                        : () => obscurePassword.value = !obscurePassword.value,
                  ),
                ),
                const SizedBox(height: 20),

                // Button đăng nhập với hiệu ứng loading
                SizedBox(
                  width: double.infinity,
                  height: 50, // Chiều cao cố định cho button
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Button login
                      AnimatedOpacity(
                        opacity: viewModel.isLoading ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: CustomButton(
                          label: 'Login',
                          onPressed: viewModel.isLoading
                              ? null
                              : () => viewModel.login(),
                        ),
                      ),

                      // Hiệu ứng loading
                      AnimatedOpacity(
                        opacity: viewModel.isLoading ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.orange,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: viewModel.isLoading
                          ? null // Vô hiệu hóa khi loading
                          : () {
                              // Chuyển đến màn hình đăng ký
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterPage()),
                              );
                            },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
