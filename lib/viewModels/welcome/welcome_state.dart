import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'welcome_state.freezed.dart';

@freezed
class WelcomeState with _$WelcomeState {
  const WelcomeState._(); // Constructor để thêm các phương thức không được tạo tự động

  const factory WelcomeState({
    required PageController pageController,
    @Default(0) int currentPage,
    String? selectedFitnessLevel,
    DateTime? selectedBirthday,
    double? height,
    double? weight,
    String? selectedGender,
    @Default(false) bool isLoading,
    String? errorMessage,
    // Thêm trạng thái UI để quản lý toàn bộ trạng thái trong ViewModel
    @Default(false) bool showErrors,
  }) = _WelcomeState;
}
