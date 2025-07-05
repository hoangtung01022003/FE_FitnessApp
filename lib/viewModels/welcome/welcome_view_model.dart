import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/services/ui/date_picker_service.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/user/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Tạo model state riêng biệt để quản lý trạng thái
class WelcomeState {
  final PageController pageController;
  final int currentPage;
  final String? selectedFitnessLevel;
  final DateTime? selectedBirthday;
  final double? height;
  final double? weight;
  final String? selectedGender;
  final bool isLoading;
  final String? errorMessage;

  WelcomeState({
    required this.pageController,
    this.currentPage = 0,
    this.selectedFitnessLevel,
    this.selectedBirthday,
    this.height,
    this.weight,
    this.selectedGender,
    this.isLoading = false,
    this.errorMessage,
  });

  // Phương thức để tạo state mới dựa trên state hiện tại
  WelcomeState copyWith({
    PageController? pageController,
    int? currentPage,
    String? selectedFitnessLevel,
    DateTime? selectedBirthday,
    double? height,
    double? weight,
    String? selectedGender,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WelcomeState(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      selectedFitnessLevel: selectedFitnessLevel ?? this.selectedFitnessLevel,
      selectedBirthday: selectedBirthday ?? this.selectedBirthday,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      selectedGender: selectedGender ?? this.selectedGender,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Định nghĩa provider sử dụng StateNotifierProvider
final welcomeViewModelProvider =
    StateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
  return WelcomeViewModel(ref);
});

// Chuyển từ ChangeNotifier sang StateNotifier
class WelcomeViewModel extends StateNotifier<WelcomeState> {
  final Ref _ref;

  WelcomeViewModel(this._ref)
      : super(WelcomeState(
          pageController: PageController(),
        ));

  void onPageChanged(int index) {
    state = state.copyWith(currentPage: index);
  }

  void goToPage(int index) {
    state.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void selectFitnessLevel(String level) {
    print('Selected fitness level: $level');
    state = state.copyWith(selectedFitnessLevel: level);
    print('Selected fitness level: ${state.selectedFitnessLevel}');
  }

  void setBirthday(DateTime? date) {
    state = state.copyWith(selectedBirthday: date);
  }

  void setHeight(double newHeight) {
    state = state.copyWith(height: newHeight);
  }

  void setWeight(double newWeight) {
    state = state.copyWith(weight: newWeight);
  }

  void selectGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  // Phương thức mới để lưu profile
  Future<bool> saveProfile() async {
    if (!validateProfile()) {
      return false;
    }

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      print(
          'Selected fitness level before save: ${state.selectedFitnessLevel}');

      final userProfile = UserProfile(
        birthday: state.selectedBirthday,
        height: state.height,
        weight: state.weight,
        gender: state.selectedGender,
        fitnessLevel: state.selectedFitnessLevel,
      );
      print('UserProfile to save: ${userProfile.toJson()}');

      await _ref
          .read(userProfileProvider.notifier)
          .createOrUpdateProfile(userProfile);

      // Đánh dấu người dùng đã hoàn thành onboarding
      await _ref.read(authNotifierProvider.notifier).completeOnboarding();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  bool validateProfile() {
    if (state.selectedBirthday == null) {
      state = state.copyWith(errorMessage: "Vui lòng chọn ngày sinh");
      return false;
    }

    if (state.height == null || state.height! <= 0) {
      state = state.copyWith(errorMessage: "Vui lòng nhập chiều cao hợp lệ");
      return false;
    }

    if (state.weight == null || state.weight! <= 0) {
      state = state.copyWith(errorMessage: "Vui lòng nhập cân nặng hợp lệ");
      return false;
    }

    if (state.selectedGender == null) {
      state = state.copyWith(errorMessage: "Vui lòng chọn giới tính");
      return false;
    }

    if (state.selectedFitnessLevel == null) {
      state = state.copyWith(errorMessage: "Vui lòng chọn mức độ thể lực");
      return false;
    }

    return true;
  }

  void printPersonalDetails() {
    print('Personal Details:');
    print(
        'Birthday: ${state.selectedBirthday?.toString().split(' ')[0] ?? 'Not selected'}');
    print('Height: ${state.height?.toStringAsFixed(0) ?? 'Not set'} cm');
    print('Weight: ${state.weight?.toStringAsFixed(0) ?? 'Not set'} kg');
    print('Gender: ${state.selectedGender ?? 'Not selected'}');
  }

  String get formattedBirthday {
    if (state.selectedBirthday == null) return "Select your birthday";
    return DateFormat('MMM dd, yyyy').format(state.selectedBirthday!);
  }

  Future<void> selectBirthday(BuildContext context) async {
    final DateTime? picked = await DatePickerService.showCustomDatePicker(
      context: context,
      initialDate: state.selectedBirthday,
      preventFutureDates: true,
    );

    if (picked != null) {
      setBirthday(picked);
    }
  }

  /// Reusable UI builder for option widgets
  Widget buildOption(BuildContext context, String title, String subtitle,
      bool isSelected, VoidCallback onTap) {
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
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
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
