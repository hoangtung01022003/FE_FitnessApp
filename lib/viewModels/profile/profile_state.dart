import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _ProfileState;
}
