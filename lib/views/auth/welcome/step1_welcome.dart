import 'package:finess_app/global/step_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';

class Step1Welcome extends ConsumerWidget {
  const Step1Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const StepText(title: "Step 1 of 3"),
                      const SizedBox(height: 20),
                      Image.asset('images/welcome.png', height: 200),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to Fitness Application",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "Personalized workouts will help you gain strength, get in better shape and embrace a healthy lifestyle",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Button and dot indicator at bottom
              Column(
                children: [
                  CustomButton(
                    label: 'Get Started',
                    onPressed: () {
                      viewModelNotifier.goToPage(1);
                    },
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
