import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tạo class state để lưu trữ trạng thái
class ExercisesState {
  final List<String> categories;
  final String selectedCategory;

  const ExercisesState({
    this.categories = const ['Full body', 'Foot', 'Arm', 'Body'],
    this.selectedCategory = 'Full body',
  });

  // Phương thức để tạo một state mới dựa trên state hiện tại
  ExercisesState copyWith({
    List<String>? categories,
    String? selectedCategory,
  }) {
    return ExercisesState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Chuyển đổi từ ChangeNotifierProvider sang StateNotifierProvider
final exercisesViewModelProvider =
    StateNotifierProvider<ExercisesViewModel, ExercisesState>(
        (ref) => ExercisesViewModel());

// Chuyển đổi từ ChangeNotifier sang StateNotifier
class ExercisesViewModel extends StateNotifier<ExercisesState> {
  ExercisesViewModel() : super(const ExercisesState());

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}
