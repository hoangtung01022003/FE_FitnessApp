import 'package:finess_app/global/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/custom_bottom_nav_bar.dart';
import 'package:finess_app/viewModels/exercises_view_model.dart';

class ExercisePage extends ConsumerWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(exercisesViewModelProvider);
    final categories = viewModel.categories;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBar(
                    title: 'Exercises',
                    showBack: true,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 10),

                  // Tabs with evenly divided space
                  SizedBox(
                    height: 40,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tabWidth =
                            constraints.maxWidth / categories.length;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                viewModel.selectedCategory == category;

                            return GestureDetector(
                              onTap: () => ref
                                  .read(exercisesViewModelProvider.notifier)
                                  .selectCategory(category),
                              child: Container(
                                width: tabWidth,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 2,
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Workout List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Workout',
                                  style: TextStyle(color: Colors.orange)),
                              const SizedBox(height: 8),
                              const Text(
                                'Climbers',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Personalized workouts will help',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'See',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
