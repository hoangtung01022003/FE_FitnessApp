import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final bool enabled; // Move this to be a proper class field

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.enabled =
        true, // Make it an optional parameter with default value true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled, // Use the enabled parameter here
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
