import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exercisesViewModelProvider =
    ChangeNotifierProvider((ref) => ExercisesViewModel());

class ExercisesViewModel extends ChangeNotifier {
  final List<String> categories = ['Full body', 'Foot', 'Arm', 'Body'];
  String selectedCategory = 'Full body';

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
