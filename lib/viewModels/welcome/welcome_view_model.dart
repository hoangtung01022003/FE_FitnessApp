import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:finess_app/viewModels/user/user_profile_provider.dart';
import 'package:finess_app/viewModels/welcome/welcome_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Định nghĩa provider sử dụng StateNotifierProvider
final welcomeViewModelProvider =
    StateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
  return WelcomeViewModel(ref);
});

// Chuyển từ ChangeNotifier sang StateNotifier với freezed state
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
    state = state.copyWith(selectedFitnessLevel: level);
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

  // Hiển thị/ẩn thông báo lỗi (quản lý UI state trong ViewModel)
  void showErrors() {
    state = state.copyWith(showErrors: true);
  }

  void hideErrors() {
    state = state.copyWith(showErrors: false);
  }

  // Phương thức mới để lưu profile
  Future<bool> saveProfile() async {
    if (!validateProfile()) {
      showErrors();
      return false;
    }

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Lấy thông tin người dùng hiện tại từ auth provider
      final authState = _ref.read(authNotifierProvider);
      final userId =
          authState.user != null ? int.tryParse(authState.user!.id) : null;

      print('Current user ID: $userId');

      // Tạo profile với user_id
      final userProfile = UserProfile(
        userId: userId, // Thêm user_id vào profile
        birthday: state.selectedBirthday,
        height: state.height,
        weight: state.weight,
        gender: state.selectedGender,
        fitnessLevel: state.selectedFitnessLevel,
      );

      // Ghi log để debug
      print('Saving profile with data: ${userProfile.toJson()}');

      await _ref
          .read(userProfileProvider.notifier)
          .createOrUpdateProfile(userProfile);

      // Đánh dấu người dùng đã hoàn thành onboarding
      await _ref.read(authNotifierProvider.notifier).completeOnboarding();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('Error saving profile: $e');
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

  String get formattedBirthday {
    if (state.selectedBirthday == null) return "Select your birthday";
    return DateFormat('MMM dd, yyyy').format(state.selectedBirthday!);
  }
}
