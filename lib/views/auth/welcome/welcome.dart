import 'package:flutter/widgets.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return const Text(
        'Welcome to the Fitness App! Please log in or register to continue.');
  }
}
