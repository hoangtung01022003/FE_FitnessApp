import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/repositories/user/user_profile_repository.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider cho UserProfileRepository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return UserProfileRepository(dio);
});

// StateNotifier để quản lý trạng thái profile
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    // Load profile khi khởi tạo
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createOrUpdateProfile(UserProfile profile) async {
    try {
      state = const AsyncValue.loading();
      final currentProfile = state.value;

      UserProfile updatedProfile;
      if (currentProfile != null && currentProfile.id != null) {
        // Nếu profile đã tồn tại, thực hiện update
        updatedProfile = await _repository.updateProfile(profile);
      } else {
        // Nếu profile chưa tồn tại, thực hiện create
        updatedProfile = await _repository.createProfile(profile);
      }

      state = AsyncValue.data(updatedProfile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider cho UserProfileNotifier
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repository);
});
