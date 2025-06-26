import 'package:flutter/material.dart';
import 'package:finess_app/views/auth/login/login_page.dart';
import 'package:finess_app/views/auth/menu_page.dart';
import 'package:finess_app/views/auth/register/register_page.dart';
import 'package:finess_app/views/auth/welcome/welcome.dart';
import 'package:finess_app/views/splash_screen.dart';

class AppRouter {
  // Định nghĩa các đường dẫn có tên
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String home = '/home';

  // Hàm để tạo routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case home:
        return MaterialPageRoute(builder: (_) => const MenuPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Không tìm thấy đường dẫn cho ${settings.name}'),
            ),
          ),
        );
    }
  }
}
