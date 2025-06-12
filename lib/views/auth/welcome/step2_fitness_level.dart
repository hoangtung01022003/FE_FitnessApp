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
    final viewModel = ref.watch(welcomeViewModelProvider);

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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      viewModel.buildOption(
                        context,
                        'Beginner',
                        'You are new to fitness training',
                        viewModel.selectedFitnessLevel == 'Beginner',
                        () => ref.read(welcomeViewModelProvider.notifier).selectFitnessLevel('Beginner'),
                      ),
                      viewModel.buildOption(
                        context,
                        'Intermediate',
                        'You have been training regularly',
                        viewModel.selectedFitnessLevel == 'Intermediate',
                        () => ref.read(welcomeViewModelProvider.notifier).selectFitnessLevel('Intermediate'),
                      ),
                      viewModel.buildOption(
                        context,
                        'Advanced',
                        'You\'re fit and ready for an intensive workout plan',
                        viewModel.selectedFitnessLevel == 'Advanced',
                        () => ref.read(welcomeViewModelProvider.notifier).selectFitnessLevel('Advanced'),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CustomButton(
                    label: 'Next',
                    onPressed: viewModel.selectedFitnessLevel == null
                        ? null
                        : () {
                            viewModel.goToPage(2);
                          },
                  ),
                  const SizedBox(height: 20),
                  TappableDotIndicator(
                    currentIndex: 1,
                    totalDots: 3,
                    onTap: viewModel.goToPage,
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