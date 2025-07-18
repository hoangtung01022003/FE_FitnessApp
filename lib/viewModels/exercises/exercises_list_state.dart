import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';

part 'exercises_list_state.freezed.dart';

@freezed
class ExercisesListState with _$ExercisesListState {
  const factory ExercisesListState({
    @Default(['Full body', 'Chest', 'Back', 'Arms', 'Legs', 'Core'])
    List<String> categories,
    @Default('Full body') String selectedCategory,
    @Default([]) List<ExerciseModel> exercises,
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    String? errorMessage,
  }) = _ExercisesListState;
}
