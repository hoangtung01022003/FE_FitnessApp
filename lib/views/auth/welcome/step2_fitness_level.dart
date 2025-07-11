import 'package:finess_app/global/step_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';

class Step2FitnessLevel extends HookConsumerWidget {
  const Step2FitnessLevel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng hooks để animation
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

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

    // Danh sách các mức độ tập luyện
    final levels = ['Beginner', 'Intermediate', 'Advanced'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: fadeAnimation,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const StepText(title: "Step 2 of 3"),
                        const SizedBox(height: 20),
                        const Text(
                          "Your Fitness Level",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "This will help us create a personalized workout plan for you",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Error message if level not selected - Sử dụng state từ ViewModel
                        if (state.showErrors &&
                            state.selectedFitnessLevel == null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              "Please select your fitness level to continue",
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 14),
                            ),
                          ),

                        // Danh sách các lựa chọn mức độ
                        ...levels
                            .map(
                              (level) => GestureDetector(
                                onTap: () {
                                  // Lưu mức độ vào state và ẩn thông báo lỗi
                                  viewModelNotifier.selectFitnessLevel(level);
                                  if (state.showErrors) {
                                    viewModelNotifier.hideErrors();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: state.selectedFitnessLevel == level
                                          ? Colors.orange
                                          : Colors.grey.shade300,
                                      width: state.selectedFitnessLevel == level
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        level,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      if (state.selectedFitnessLevel == level)
                                        const Icon(Icons.check_circle,
                                            color: Colors.orange),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
                          viewModelNotifier.goToPage(0);
                        },
                        child: const Text('Back'),
                      ),
                      CustomButton(
                        label: 'Continue',
                        onPressed: () {
                          // Kiểm tra đã chọn level chưa
                          if (state.selectedFitnessLevel == null) {
                            viewModelNotifier.showErrors();
                            // Hiển thị thông báo lỗi
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please select your fitness level to continue'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            viewModelNotifier.goToPage(2);
                          }
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
