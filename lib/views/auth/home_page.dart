import 'package:finess_app/utils/image_helper.dart';
import 'package:finess_app/viewModels/exercises/exercises_list_view_model.dart';
import 'package:finess_app/views/exercise/exercises_list_page.dart';
import 'package:finess_app/views/workout/workout_session_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/viewModels/home/home_view_model.dart';
import 'package:finess_app/views/exercise/exercise_detail_page.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use hooks to track widget lifecycle
    final isFirstBuild = useRef(true);
    final searchController = useTextEditingController();

    // Animation controller for UI effects
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Create animation for card
    final cardAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Get state and notifier from view model
    final state = ref.watch(homeViewModelProvider);
    final viewModelNotifier = ref.read(homeViewModelProvider.notifier);
    final exercisesViewModel =
        ref.read(exercisesListViewModelProvider.notifier);

    // Run animation when widget is built for the first time
    useEffect(() {
      if (isFirstBuild.value) {
        animationController.forward();
        isFirstBuild.value = false;
      }
      return null;
    }, const []);

    // Handle when user taps on an exercise
    void navigateToExerciseDetail(int index) {
      if (state.todayWorkout != null) {
        final exercise = state.todayWorkout!.exercises[index].exercise;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailPage(exercise: exercise),
          ),
        );
      }
    }

    // Navigate to category page
    void navigateToCategory(String category) {
      exercisesViewModel.selectCategory(category);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ExercisesListPage(),
        ),
      );
    }

    // Pull to refresh functionality
    Future<void> _handleRefresh() async {
      await viewModelNotifier.loadTodayWorkout();
      await viewModelNotifier.loadCategories();
      return;
    }

    return Scaffold(
      body: SafeArea(
        child: state.isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.orange,
                  size: 60,
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
                            'Error: ${state.errorMessage ?? "Unable to load data"}'),
                        const SizedBox(height: 16),
                        CustomButton(
                          label: 'Try Again',
                          onPressed: () => viewModelNotifier.loadTodayWorkout(),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: Colors.orange,
                    child: Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            const HeaderBar(
                                title: 'Fitness Application', showBack: false),
                            const SizedBox(height: 20),

                            // Search bar
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search,
                                      color: Colors.grey.shade600),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search exercises...',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          // Implement search functionality
                                          // viewModelNotifier.searchExercises(value);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Featured workout section
                            const Text(
                              'Today\'s Workout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Apply animation to card
                            AnimatedOpacity(
                              opacity: cardAnimation,
                              duration: const Duration(milliseconds: 300),
                              child: Card(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.todayWorkout?.title ??
                                                    'Today\'s Training Session',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                state.todayWorkout?.week ??
                                                    'Week 1',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.orange
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              '20 minutes',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 8),

                                      // Exercise list
                                      if (state.todayWorkout != null)
                                        ...state.todayWorkout!.exercises
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final workoutExercise = entry.value;
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    navigateToExerciseDetail(
                                                        index),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 60,
                                                        height: 60,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: ImageHelper
                                                              .networkImageWithProxy(
                                                            imageUrl:
                                                                workoutExercise
                                                                    .exercise
                                                                    .gifUrl,
                                                            fit: BoxFit.cover,
                                                            width: 60,
                                                            height: 60,
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
                                                              workoutExercise
                                                                  .exercise
                                                                  .name,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '${workoutExercise.sets} sets × ${workoutExercise.reps} reps',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Container(
                                                                  width: 4,
                                                                  height: 4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  workoutExercise
                                                                      .duration,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Wrap(
                                                              children: workoutExercise
                                                                  .exercise
                                                                  .targetMuscles
                                                                  .take(2)
                                                                  .map((muscle) =>
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                6,
                                                                            vertical:
                                                                                2),
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                4),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .orange
                                                                              .withOpacity(0.1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          muscle,
                                                                          style: const TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.orange),
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(Icons.navigate_next,
                                                          color: Colors
                                                              .grey.shade400)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (index <
                                                  state.todayWorkout!.exercises
                                                          .length -
                                                      1)
                                                Divider(
                                                    color:
                                                        Colors.grey.shade200),
                                            ],
                                          );
                                        }).toList(),

                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: CustomButton(
                                          label: 'Start Workout',
                                          onPressed: () {
                                            viewModelNotifier.startWorkout();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const WorkoutSessionPage()),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Recommended workout categories
                            const Text(
                              'Exercise Categories',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Display categories from API
                            state.isLoadingCategories
                                ? Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      color: Colors.orange,
                                      size: 40,
                                    ),
                                  )
                                : state.categories.isEmpty
                                    ? Center(
                                        child: Column(
                                          children: [
                                            Icon(Icons.category_outlined,
                                                size: 48,
                                                color: Colors.grey.shade400),
                                            const SizedBox(height: 8),
                                            const Text('No categories found'),
                                            const SizedBox(height: 16),
                                            CustomButton(
                                              label: 'Reload',
                                              onPressed: () => viewModelNotifier
                                                  .loadCategories(),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 1.5,
                                        ),
                                        itemCount: state.categories.length,
                                        itemBuilder: (context, index) {
                                          final category =
                                              state.categories[index];
                                          return _buildCategoryCard(
                                            category.name,
                                            category.imageUrl,
                                            () => navigateToCategory(
                                                category.name),
                                          );
                                        },
                                      ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use ImageHelper for CORS support in web
            ImageHelper.networkImageWithProxy(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
            // Overlay to darken image and improve text readability
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            // Category title
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
