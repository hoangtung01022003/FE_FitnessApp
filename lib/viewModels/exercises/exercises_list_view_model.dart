import 'package:finess_app/viewModels/home/home_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/repositories/exercise_repository.dart';
import 'package:finess_app/viewModels/exercises/exercises_list_state.dart';

final exercisesListViewModelProvider =
    StateNotifierProvider<ExercisesListViewModel, ExercisesListState>(
        (ref) => ExercisesListViewModel(ref.read(exerciseRepositoryProvider)));

class ExercisesListViewModel extends StateNotifier<ExercisesListState> {
  final ExerciseRepository _exerciseRepository;

  ExercisesListViewModel(this._exerciseRepository)
      : super(const ExercisesListState()) {
    // Load exercises for the default category when initialized
    loadExercises();
  }

  void selectCategory(String category) {
    state = state.copyWith(
      selectedCategory: category,
      exercises: [], // Clear current exercises
      isLoading: true,
      isError: false,
      errorMessage: null,
    );
    loadExercises();
  }

  Future<void> loadExercises() async {
    try {
      state = state.copyWith(
        isLoading: true,
        isError: false,
        errorMessage: null,
      );

      // Map category to the corresponding API parameter
      final String bodyPart = _mapCategoryToBodyPart(state.selectedCategory);

      // Fetch exercises from repository based on selected category
      final exercises =
          await _exerciseRepository.getExercisesByBodyPart(bodyPart);

      state = state.copyWith(
        exercises: exercises,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }

  // Helper method to map UI categories to API bodyPart values
  String _mapCategoryToBodyPart(String category) {
    switch (category.toLowerCase()) {
      case 'chest':
        return 'chest';
      case 'back':
        return 'back';
      case 'arms':
        return 'upper arms';
      case 'legs':
        return 'upper legs';
      case 'core':
        return 'waist';
      case 'full body':
      default:
        return 'full body';
    }
  }
}
