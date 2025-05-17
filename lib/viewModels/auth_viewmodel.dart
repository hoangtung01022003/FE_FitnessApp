import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isNotEmpty(String text) {
    return text.trim().isNotEmpty;
  }

  static bool passwordsMatch(String pass1, String pass2) {
    return pass1 == pass2;
  }
}
