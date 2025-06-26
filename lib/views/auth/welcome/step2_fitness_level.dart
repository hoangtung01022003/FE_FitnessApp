import 'package:finess_app/global/step_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';

class Step2FitnessLevel extends ConsumerWidget {
  const Step2FitnessLevel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tách biệt state và notifier theo đúng mô hình MVVM
    final state = ref.watch(welcomeViewModelProvider);
    final notifier = ref.read(welcomeViewModelProvider.notifier);

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
                      const StepText(
                        title: "Step 2 of 3",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Select your fitness level",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      notifier.buildOption(
                        context,
                        'Beginner',
                        'You are new to fitness training',
                        state.selectedFitnessLevel == 'Beginner',
                        () => notifier.selectFitnessLevel('Beginner'),
                      ),
                      notifier.buildOption(
                        context,
                        'Intermediate',
                        'You have been training regularly',
                        state.selectedFitnessLevel == 'Intermediate',
                        () => notifier.selectFitnessLevel('Intermediate'),
                      ),
                      notifier.buildOption(
                        context,
                        'Advanced',
                        'You\'re fit and ready for an intensive workout plan',
                        state.selectedFitnessLevel == 'Advanced',
                        () => notifier.selectFitnessLevel('Advanced'),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CustomButton(
                    label: 'Next',
                    onPressed: state.selectedFitnessLevel == null
                        ? null
                        : () {
                            notifier.goToPage(2);
                          },
                  ),
                  const SizedBox(height: 20),
                  TappableDotIndicator(
                    currentIndex: 1,
                    totalDots: 3,
                    onTap: notifier.goToPage,
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
