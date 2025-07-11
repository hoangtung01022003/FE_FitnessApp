import 'package:finess_app/global/step_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';
import 'package:finess_app/global/widgets/date_picker_field.dart';
import 'package:finess_app/global/widgets/gender_selector.dart';
import 'package:finess_app/global/widgets/number_picker_field.dart';

class Step3PersonalDetails extends HookConsumerWidget {
  const Step3PersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng hooks để quản lý animation
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Animation
    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Chạy animation khi widget được render
    useEffect(() {
      animationController.forward();
      return null;
    }, const []);

    // Truy cập notifier để gọi các phương thức
    final viewModelNotifier = ref.read(welcomeViewModelProvider.notifier);
    // Truy cập state để lấy dữ liệu
    final state = ref.watch(welcomeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedOpacity(
                    opacity: fadeAnimation,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const StepText(title: "Step 3 of 3"),
                        const SizedBox(height: 20),
                        const Text(
                          "Personal Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "We'll use this information to create your personalized plan",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Date picker widget
                        DatePickerField(
                          label: 'Date of Birth',
                          selectedDate: state.selectedBirthday,
                          onDateSelected: (date) {
                            viewModelNotifier.setBirthday(date);
                            if (state.showErrors) {
                              viewModelNotifier.hideErrors();
                            }
                          },
                          isError: state.showErrors &&
                              state.selectedBirthday == null,
                          errorMessage:
                              state.showErrors && state.selectedBirthday == null
                                  ? "Please select your date of birth"
                                  : null,
                        ),

                        // Weight picker widget
                        NumberPickerField(
                          label: 'Weight',
                          suffix: 'kg',
                          value: state.weight,
                          onValueSelected: (value) {
                            viewModelNotifier.setWeight(value);
                            if (state.showErrors) {
                              viewModelNotifier.hideErrors();
                            }
                          },
                          isError: state.showErrors &&
                              (state.weight == null || state.weight! <= 0),
                          errorMessage: state.showErrors &&
                                  (state.weight == null || state.weight! <= 0)
                              ? "Please select your weight"
                              : null,
                          minValue: 30,
                          maxValue: 200,
                          icon: Icons.fitness_center,
                        ),

                        // Height picker widget
                        NumberPickerField(
                          label: 'Height',
                          suffix: 'cm',
                          value: state.height,
                          onValueSelected: (value) {
                            viewModelNotifier.setHeight(value);
                            if (state.showErrors) {
                              viewModelNotifier.hideErrors();
                            }
                          },
                          isError: state.showErrors &&
                              (state.height == null || state.height! <= 0),
                          errorMessage: state.showErrors &&
                                  (state.height == null || state.height! <= 0)
                              ? "Please select your height"
                              : null,
                          minValue: 100,
                          maxValue: 220,
                          icon: Icons.height,
                        ),

                        // Gender selection widget
                        GenderSelector(
                          selectedGender: state.selectedGender,
                          onGenderSelected: (gender) {
                            viewModelNotifier.selectGender(gender);
                            if (state.showErrors) {
                              viewModelNotifier.hideErrors();
                            }
                          },
                          showError:
                              state.showErrors && state.selectedGender == null,
                          errorMessage:
                              state.showErrors && state.selectedGender == null
                                  ? "Please select your gender"
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Button và dot indicator ở dưới
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          viewModelNotifier.goToPage(1);
                        },
                        child: const Text('Back'),
                      ),
                      CustomButton(
                        label: state.isLoading ? 'Saving...' : 'Complete',
                        onPressed: state.isLoading
                            ? null
                            : () {
                                // Cập nhật thông tin và hoàn thành onboarding
                                viewModelNotifier.saveProfile().then((success) {
                                  if (success) {
                                    // Nếu lưu thành công, điều hướng đến trang chính
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  } else {
                                    // Hiển thị lỗi nếu có
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.errorMessage ??
                                            'Error saving profile'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                });
                              },
                        width: 150,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TappableDotIndicator(
                    currentIndex: state.currentPage,
                    totalDots: 3,
                    onTap: viewModelNotifier.goToPage,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
