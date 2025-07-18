import 'package:cached_network_image/cached_network_image.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/viewModels/exercises/exercises_list_view_model.dart';
import 'package:finess_app/views/exercise/exercise_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ExercisesListPage extends HookConsumerWidget {
  const ExercisesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exercisesListViewModelProvider);
    final viewModel = ref.read(exercisesListViewModelProvider.notifier);

    // Animation controller for UI effects
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Use useEffect to run animation when widget is built
    useEffect(() {
      animationController.forward();
      return null;
    }, const []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(
              title: '${state.selectedCategory} Exercises',
              showBack: true,
            ),
            const SizedBox(height: 16),

            // Horizontal scrollable exercise categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  final isSelected = category == state.selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => viewModel.selectCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.orange : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Main content: exercise list or loading/error states
            Expanded(
              child: state.isLoading
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.orange,
                        size: 50,
                      ),
                    )
                  : state.isError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 60, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.errorMessage ?? "Unable to load data"}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => viewModel.loadExercises(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        )
                      : state.exercises.isEmpty
                          ? const Center(
                              child:
                                  Text('No exercises found in this category'),
                            )
                          : AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) {
                                return ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: state.exercises.length,
                                  itemBuilder: (context, index) {
                                    final exercise = state.exercises[index];

                                    // Create staggered animation for each item
                                    final itemAnimation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                          (1 / state.exercises.length) * index,
                                          1.0,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    );

                                    return AnimatedOpacity(
                                      opacity: itemAnimation.value,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Transform.translate(
                                        offset: Offset(
                                            0, 20 * (1 - itemAnimation.value)),
                                        child: Card(
                                          elevation: 2,
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ExerciseDetailPage(
                                                          exercise: exercise),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            exercise.gifUrl,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          color: Colors
                                                              .grey.shade200,
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          color: Colors
                                                              .grey.shade200,
                                                          child: const Icon(
                                                            Icons
                                                                .fitness_center,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          exercise.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),

                                                        // Target muscles
                                                        Wrap(
                                                          spacing: 4,
                                                          runSpacing: 4,
                                                          children: exercise
                                                              .targetMuscles
                                                              .map(
                                                                  (muscle) =>
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                4),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .orange
                                                                              .withOpacity(0.2),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          muscle,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.orange,
                                                                          ),
                                                                        ),
                                                                      ))
                                                              .toList(),
                                                        ),

                                                        const SizedBox(
                                                            height: 8),

                                                        // Equipment info
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .fitness_center,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                            const SizedBox(
                                                                width: 4),
                                                            Expanded(
                                                              child: Text(
                                                                exercise.equipments
                                                                        .isNotEmpty
                                                                    ? exercise
                                                                        .equipments
                                                                        .join(
                                                                            ", ")
                                                                    : 'No equipment',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
          ],
        ),
      ),
    );
  }
}
