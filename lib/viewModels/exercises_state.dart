import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercises_state.freezed.dart';

@freezed
class ExercisesState with _$ExercisesState {
  const factory ExercisesState({
    @Default(['Full body', 'Foot', 'Arm', 'Body']) List<String> categories,
    @Default('Full body') String selectedCategory,
  }) = _ExercisesState;
}
