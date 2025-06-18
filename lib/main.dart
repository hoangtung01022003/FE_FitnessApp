import 'package:finess_app/views/auth/menu_page.dart';
import 'package:finess_app/views/auth/welcome/step1_welcome.dart';
import 'package:finess_app/views/auth/welcome/step3_personal_details.dart';
import 'package:finess_app/views/auth/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/auth/index.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fitness App',
      home: MenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
