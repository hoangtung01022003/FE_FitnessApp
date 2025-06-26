import 'package:finess_app/views/auth/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/viewModels/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tách biệt state và notifier theo mô hình MVVM
    // final state = ref.watch(homeViewModelProvider);
    final viewModelNotifier = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBar(title: 'Fitness Application', showBack: true),
                  const SizedBox(height: 20),

                  // Begin embedded TrainingCard content
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Training Day 1',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 4),
                              const Text('Week 1',
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 16),
                              viewModelNotifier.buildExerciseRow(
                                icon: Icons.looks_one,
                                label: 'Exercises 1',
                                time: '7 min',
                                iconColor: Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              viewModelNotifier.buildExerciseRow(
                                icon: Icons.looks_two,
                                label: 'Exercises 2',
                                time: '15 min',
                                iconColor: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              viewModelNotifier.buildExerciseRow(
                                icon: Icons.star,
                                label: 'Finished',
                                time: '5 min',
                                iconColor: Colors.black26,
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: CustomButton(
                                  label: 'Start',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const ExercisePage()),
                                    );
                                  }, // Add action here if needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // End card
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
