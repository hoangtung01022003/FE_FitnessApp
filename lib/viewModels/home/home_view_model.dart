import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';
import 'package:finess_app/repositories/exercise_repository.dart';
import 'package:finess_app/viewModels/home/home_state.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository();
});

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => HomeViewModel(ref));

class HomeViewModel extends StateNotifier<HomeState> {
  final Ref _ref;

  HomeViewModel(this._ref) : super(const HomeState()) {
    // Tải bài tập khi khởi tạo ViewModel
    loadTodayWorkout();
    loadCategories(); // Tải danh mục bài tập
  }

  ExerciseRepository get _exerciseRepository =>
      _ref.read(exerciseRepositoryProvider);

  // Tải danh mục bài tập từ API
  Future<void> loadCategories() async {
    try {
      state = state.copyWith(isLoadingCategories: true);

      // Lấy dữ liệu các body parts từ API
      final bodyParts = await _exerciseRepository.getAllBodyParts();

      // Lấy một bài tập đại diện cho mỗi body part để hiển thị ảnh
      final categories = <CategoryModel>[];

      for (final bodyPart in bodyParts) {
        try {
          final exercises =
              await _exerciseRepository.getExercisesByBodyPart(bodyPart);
          if (exercises.isNotEmpty) {
            // Lấy URL ảnh GIF từ bài tập đầu tiên của body part này
            categories.add(CategoryModel(
              name: bodyPart,
              imageUrl: exercises.first.gifUrl,
            ));
          }
        } catch (e) {
          // Bỏ qua lỗi khi tải một body part cụ thể
          print('Lỗi khi tải bài tập cho $bodyPart: $e');
        }
      }

      state = state.copyWith(
        categories: categories,
        isLoadingCategories: false,
      );
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
      state = state.copyWith(isLoadingCategories: false);
    }
  }

  Future<void> loadTodayWorkout() async {
    try {
      state =
          state.copyWith(isLoading: true, isError: false, errorMessage: null);
      final workoutPlan = await _exerciseRepository.getTodayWorkoutPlan();
      state = state.copyWith(
        isLoading: false,
        todayWorkout: workoutPlan,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }

  void updateSelectedWorkout(String workout) {
    state = state.copyWith(selectedWorkout: workout);
  }

  void startWorkout() {
    state = state.copyWith(
      isWorkoutMode: true,
      currentExerciseIndex: 0,
      isPaused: false,
    );
  }

  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
  }

  void resumeWorkout() {
    state = state.copyWith(isPaused: false);
  }

  void skipExercise() {
    if (state.todayWorkout == null) return;

    final nextIndex = state.currentExerciseIndex + 1;
    if (nextIndex >= state.todayWorkout!.exercises.length) {
      // Nếu đã là bài tập cuối cùng, kết thúc buổi tập
      endWorkout();
    } else {
      // Chuyển sang bài tập tiếp theo
      state = state.copyWith(currentExerciseIndex: nextIndex);
    }
  }

  void markCurrentExerciseComplete() {
    if (state.todayWorkout == null) return;

    final currentExercise =
        state.todayWorkout!.exercises[state.currentExerciseIndex];
    final updatedExercise = currentExercise.copyWith(isCompleted: true);

    final updatedExercises = [...state.todayWorkout!.exercises];
    updatedExercises[state.currentExerciseIndex] = updatedExercise;

    final updatedWorkout = WorkoutPlan(
      title: state.todayWorkout!.title,
      week: state.todayWorkout!.week,
      exercises: updatedExercises,
    );

    state = state.copyWith(todayWorkout: updatedWorkout);
    skipExercise();
  }

  void endWorkout() {
    state = state.copyWith(
      isWorkoutMode: false,
      currentExerciseIndex: 0,
      isPaused: false,
    );
  }

  // Khởi động lại buổi tập từ đầu với tất cả bài tập được đánh dấu là chưa hoàn thành
  void restartWorkout() {
    if (state.todayWorkout == null) {
      // Nếu không có buổi tập nào để khởi động lại, tải một buổi tập mới
      loadTodayWorkout();
      return;
    }

    // Đặt lại tất cả bài tập thành chưa hoàn thành
    final resetExercises = state.todayWorkout!.exercises.map((exercise) {
      return exercise.copyWith(isCompleted: false);
    }).toList();

    // Tạo kế hoạch bài tập được cập nhật với các bài tập đã đặt lại
    final updatedWorkout = WorkoutPlan(
      title: state.todayWorkout!.title,
      week: state.todayWorkout!.week,
      exercises: resetExercises,
    );

    // Cập nhật trạng thái để bắt đầu buổi tập từ đầu
    state = state.copyWith(
      todayWorkout: updatedWorkout,
      isWorkoutMode: true,
      currentExerciseIndex: 0,
      isPaused: false,
    );
  }

  WorkoutExercise? get currentExercise {
    if (state.todayWorkout == null ||
        state.currentExerciseIndex >= state.todayWorkout!.exercises.length) {
      return null;
    }
    return state.todayWorkout!.exercises[state.currentExerciseIndex];
  }

  bool get isLastExercise {
    if (state.todayWorkout == null) return true;
    return state.currentExerciseIndex ==
        state.todayWorkout!.exercises.length - 1;
  }

  Widget buildExerciseRow({
    required IconData icon,
    required String label,
    required String time,
    required Color iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        const Icon(Icons.info_outline, color: Colors.grey),
      ],
    );
  }
}
