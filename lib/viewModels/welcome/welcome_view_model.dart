import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final welcomeViewModelProvider = ChangeNotifierProvider((ref) => WelcomeViewModel());

class WelcomeViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  String? selectedFitnessLevel;
  DateTime? selectedBirthday;
  double? height;
  double? weight;
  String? selectedGender;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void selectFitnessLevel(String level) {
    selectedFitnessLevel = level;
    print('Selected fitness level: $level');
    notifyListeners();
  }

  void selectBirthday(DateTime date) {
    selectedBirthday = date;
    notifyListeners();
  }

  void setHeight(double newHeight) {
    height = newHeight;
    notifyListeners();
  }

  void setWeight(double newWeight) {
    weight = newWeight;
    notifyListeners();
  }

  void selectGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void printPersonalDetails() {
    print('Personal Details:');
    print('Birthday: ${selectedBirthday?.toString().split(' ')[0] ?? 'Not selected'}');
    print('Height: ${height?.toStringAsFixed(0) ?? 'Not set'} cm');
    print('Weight: ${weight?.toStringAsFixed(0) ?? 'Not set'} kg');
    print('Gender: ${selectedGender ?? 'Not selected'}');
  }


  /// Reusable UI builder for option widgets
  Widget buildOption(BuildContext context, String title, String subtitle, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
