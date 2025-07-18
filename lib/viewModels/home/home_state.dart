import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default('') String selectedWorkout,
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    String? errorMessage,
    WorkoutPlan? todayWorkout,
    @Default(0) int currentExerciseIndex,
    @Default(false) bool isWorkoutMode,
    @Default(false) bool isPaused,
    @Default([]) List<CategoryModel> categories,
    @Default(false) bool isLoadingCategories,
  }) = _HomeState;
}

class CategoryModel {
  final String name;
  final String imageUrl;

  CategoryModel({required this.name, required this.imageUrl});
}
