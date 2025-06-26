import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/views/auth/welcome/step1_welcome.dart';
import 'package:finess_app/views/auth/welcome/step2_fitness_level.dart';
import 'package:finess_app/views/auth/welcome/step3_personal_details.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tách biệt state và notifier theo mô hình MVVM
    final state = ref.watch(welcomeViewModelProvider);
    final viewModelNotifier = ref.read(welcomeViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: state.pageController,
              onPageChanged: viewModelNotifier.onPageChanged,
              children: const [
                Step1Welcome(),
                Step2FitnessLevel(),
                Step3PersonalDetails(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
