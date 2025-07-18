import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/viewModels/profile/profile_state.dart';
import 'package:finess_app/viewModels/user/user_profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  final userProfileNotifier = ref.watch(userProfileProvider.notifier);
  return ProfileViewModel(ref, userProfileNotifier);
});

class ProfileViewModel extends StateNotifier<ProfileState> {
  final Ref _ref;
  final UserProfileNotifier _userProfileNotifier;

  ProfileViewModel(this._ref, this._userProfileNotifier)
      : super(const ProfileState());

  // Chuyển đổi giữa chế độ xem và chế độ chỉnh sửa
  void toggleEditMode() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  // Cập nhật thông tin profile
  Future<void> updateProfile({
    String? fitnessLevel,
    DateTime? birthday,
    double? height,
    double? weight,
    String? gender,
  }) async {
    try {
      state = state.copyWith(isSaving: true, errorMessage: null);

      // Lấy profile hiện tại
      final currentProfile = _ref.read(userProfileProvider).value;
      if (currentProfile == null) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Không thể cập nhật profile: Không có dữ liệu profile',
        );
        return;
      }

      // Tạo profile mới với các thông tin đã cập nhật
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fitnessLevel: fitnessLevel ?? currentProfile.fitnessLevel,
        birthday: birthday ?? currentProfile.birthday,
        height: height ?? currentProfile.height,
        weight: weight ?? currentProfile.weight,
        gender: gender ?? currentProfile.gender,
      );

      // Gọi API để cập nhật profile
      await _userProfileNotifier.createOrUpdateProfile(updatedProfile);

      // Chuyển về chế độ xem sau khi cập nhật thành công
      state = state.copyWith(isSaving: false, isEditing: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Lỗi khi cập nhật profile: ${e.toString()}',
      );
    }
  }
}
