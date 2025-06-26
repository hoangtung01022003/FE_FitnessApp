import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/services/storage/auth_storage_provider.dart';
import 'package:finess_app/views/auth/login/login_page.dart';
import 'package:finess_app/views/auth/welcome/welcome.dart';
import 'package:finess_app/views/auth/menu_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  // Kiểm tra trạng thái xác thực và điều hướng phù hợp
  Future<void> _checkAuthState() async {
    // Đợi một chút để hiển thị splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Lấy service kiểm tra trạng thái đăng nhập
    final authStorage = ref.read(authStorageProvider);

    // Kiểm tra người dùng đã đăng nhập chưa
    final isLoggedIn = await authStorage.isLoggedIn();

    if (!isLoggedIn) {
      // Nếu chưa đăng nhập, chuyển đến trang đăng nhập
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
      return;
    }

    // Người dùng đã đăng nhập, kiểm tra đã hoàn thành onboarding chưa
    final hasCompletedOnboarding = await authStorage.hasCompletedOnboarding();

    if (mounted) {
      if (!hasCompletedOnboarding) {
        // Nếu chưa hoàn thành onboarding, chuyển đến màn hình welcome
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Welcome()),
        );
      } else {
        // Nếu đã hoàn thành onboarding, chuyển đến màn hình chính
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/welcome.png',
              height: 120,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fitness App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
