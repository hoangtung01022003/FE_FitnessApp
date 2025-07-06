import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/viewModels/exercises_state.dart';

final exercisesViewModelProvider =
    StateNotifierProvider<ExercisesViewModel, ExercisesState>(
        (ref) => ExercisesViewModel());

class ExercisesViewModel extends StateNotifier<ExercisesState> {
  ExercisesViewModel() : super(const ExercisesState());

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  // Thêm các phương thức mới để làm việc với exercises

  void filterExercisesByCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    // Ở đây bạn có thể gọi API hoặc lọc danh sách exercises theo category
  }

  void refreshExercises() {
    // Có thể cập nhật state với loading = true
    // Gọi API để lấy dữ liệu mới
    // Cập nhật state với dữ liệu mới và loading = false
  }
}
