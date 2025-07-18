import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';
import 'package:finess_app/utils/image_helper.dart';
import 'package:finess_app/viewModels/home/home_view_model.dart';

class WorkoutSessionPage extends HookConsumerWidget {
  const WorkoutSessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModelNotifier = ref.read(homeViewModelProvider.notifier);

    // Get current exercise information
    final currentExercise = viewModelNotifier.currentExercise;

    // Use hooks to track if the workout completion dialog has been shown
    final hasShownCompletionDialog = useRef(false);

    // Use hooks to create countdown timer
    final countdownSeconds =
        useState(30); // Default 30 seconds for each exercise
    final isResting = useState(false);
    final restSeconds = useState(10); // Rest time between exercises

    // Show dialog when workout is completed
    void showWorkoutCompletionDialog(
        BuildContext context, VoidCallback onRestart) {
      showDialog(
        context: context,
        barrierDismissible: false, // User must select an option
        builder: (context) => AlertDialog(
          title: const Text('Workout Completed!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Congratulations! You have completed all exercises.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Would you like to restart the workout or return to home?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous page
              },
              child: const Text('Return to Home'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onRestart();
              },
              child: const Text('Restart Workout'),
            ),
          ],
        ),
      );
    }

    // Create timer with useEffect
    useEffect(() {
      Timer? timer;

      // Only run timer when not in pause mode
      if (!state.isPaused && currentExercise != null) {
        if (isResting.value) {
          // Timer for rest time
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (restSeconds.value > 0) {
              restSeconds.value--;
            } else {
              // End rest time
              timer.cancel();
              isResting.value = false;
              countdownSeconds.value = 30; // Reset exercise time
            }
          });
        } else {
          // Timer for exercise time
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (countdownSeconds.value > 0) {
              countdownSeconds.value--;
            } else {
              // End current exercise
              timer.cancel();

              // Mark exercise as completed and move to next
              viewModelNotifier.markCurrentExerciseComplete();

              // If there are more exercises, start rest time
              if (!viewModelNotifier.isLastExercise) {
                isResting.value = true;
                restSeconds.value = 10; // Reset rest time
              }
            }
          });
        }
      }

      // Cleanup timer when widget is disposed
      return () {
        timer?.cancel();
      };
    }, [state.isPaused, state.currentExerciseIndex, isResting.value]);

    // Show workout completion dialog when all exercises are done
    useEffect(() {
      // Check if all exercises are completed and dialog hasn't been shown yet
      if (currentExercise == null && !hasShownCompletionDialog.value) {
        // Set flag to prevent showing the dialog multiple times
        hasShownCompletionDialog.value = true;

        // Use Future.microtask to show dialog after build is complete
        Future.microtask(() {
          showWorkoutCompletionDialog(context, () {
            // Restart workout
            viewModelNotifier.restartWorkout();
            hasShownCompletionDialog.value = false;
          });
        });
      }
      return null;
    }, [currentExercise]);

    // Handle when user presses "Continue/Pause" button
    void handlePlayPause() {
      if (state.isPaused) {
        viewModelNotifier.resumeWorkout();
      } else {
        viewModelNotifier.pauseWorkout();
      }
    }

    // Handle when user presses "Skip" button
    void handleSkip() {
      isResting.value = false;
      countdownSeconds.value = 30; // Reset time for next exercise
      viewModelNotifier.skipExercise();
    }

    // Handle when user presses "End" button
    void handleEndWorkout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('End Workout'),
          content: const Text('Are you sure you want to end this workout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                viewModelNotifier.endWorkout();
                Navigator.pop(context); // Return to previous page

                // Show completion message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Congratulations! You have completed the workout!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('End'),
            ),
          ],
        ),
      );
    }

    // Handle case when there is no exercise
    if (currentExercise == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sentiment_satisfied, size: 60),
              const SizedBox(height: 16),
              const Text('Congratulations! You have completed the workout!'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: const Text('Return to Home'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModelNotifier.restartWorkout();
                      hasShownCompletionDialog.value = false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Restart Workout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Title bar with back button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => handleEndWorkout(),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  Text(
                    isResting.value
                        ? 'Rest Time'
                        : 'Exercise ${state.currentExerciseIndex + 1}/${state.todayWorkout?.exercises.length ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () => handleSkip(),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: isResting.value
                  ? _buildRestingView(restSeconds.value)
                  : _buildExerciseView(
                      context, currentExercise, countdownSeconds.value),
            ),

            // Control bar at bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: handlePlayPause,
                    icon: Icon(
                      state.isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: handleSkip,
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: handleEndWorkout,
                    icon: const Icon(
                      Icons.stop,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget displayed during exercise
  Widget _buildExerciseView(
      BuildContext context, WorkoutExercise exercise, int seconds) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exercise name
          Text(
            exercise.exercise.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Display animated image (GIF) using ImageHelper for CORS support
          ImageHelper.networkImageWithProxy(
            imageUrl: exercise.exercise.gifUrl,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),

          // Exercise information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  title: 'Sets',
                  value: '${exercise.sets}',
                  icon: Icons.repeat,
                ),
                _buildInfoItem(
                  title: 'Reps',
                  value: '${exercise.reps}',
                  icon: Icons.fitness_center,
                ),
                _buildInfoItem(
                  title: 'Time',
                  value: '$seconds seconds',
                  icon: Icons.timer,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          LinearProgressIndicator(
            value: seconds / 30, // Assuming total time is 30 seconds
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  // Widget displayed during rest time
  Widget _buildRestingView(int seconds) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timer,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Rest Break',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prepare for the next exercise',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.3),
            ),
            child: Text(
              '$seconds',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget displaying exercise information
  Widget _buildInfoItem(
      {required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
