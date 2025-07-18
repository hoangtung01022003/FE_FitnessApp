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
  int _retryCount = 0;
  static const int maxRetries = 3;
  bool _isInitialLoad = true;

  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    // Load profile khi khởi tạo
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (_retryCount >= maxRetries) {
      // Reset retry count nhưng giữ trạng thái lỗi hiện tại
      _retryCount = 0;

      // Nếu đây là lần tải đầu tiên, chuyển sang trạng thái "không có profile"
      if (_isInitialLoad) {
        _isInitialLoad = false;
        state = const AsyncValue.data(
            null); // Đánh dấu là không có profile thay vì lỗi
        print('Không thể tải profile, chuyển sang trạng thái không có profile');
      }
      return;
    }

    try {
      // Chỉ hiển thị loading trong lần đầu tiên hoặc khi người dùng chủ động tải lại
      if (_isInitialLoad) {
        state = const AsyncValue.loading();
      }

      final profile = await _repository.getProfile();
      _retryCount = 0; // Reset retry count khi thành công
      _isInitialLoad = false;
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      print('Error loading profile: $e');
      _retryCount++;

      // Kiểm tra xem có nên thử lại không
      if (_retryCount < maxRetries) {
        print('Retrying loadProfile... Attempt $_retryCount');
        // Đợi 1 giây trước khi thử lại
        await Future.delayed(const Duration(seconds: 1));
        return loadProfile(); // Thử lại
      } else {
        // Nếu đây là lần tải đầu tiên, chuyển sang trạng thái "không có profile"
        if (_isInitialLoad) {
          _isInitialLoad = false;
          state = const AsyncValue.data(
              null); // Đánh dấu là không có profile thay vì lỗi
          print(
              'Không thể tải profile sau nhiều lần thử, chuyển sang trạng thái không có profile');
        } else {
          // Nếu không phải lần tải đầu tiên, giữ nguyên trạng thái trước đó
          // Hiển thị thông báo lỗi nhẹ nhàng hơn
          String errorMessage =
              'Không thể cập nhật thông tin profile lúc này. Vui lòng thử lại sau.';
          print(errorMessage);
          // Giữ nguyên state hiện tại nếu đã có dữ liệu, chỉ đặt lỗi nếu đang loading
          if (state is AsyncLoading) {
            state = AsyncValue.error(errorMessage, stackTrace);
          }
        }
        _retryCount = 0; // Reset retry count
      }
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
      // Giữ dữ liệu profile cũ nếu có
      final currentProfile = state.value;
      if (currentProfile != null) {
        state = AsyncValue.data(currentProfile);
      } else {
        state = AsyncValue.error(e, stackTrace);
      }

      // Ném lỗi để UI có thể hiển thị thông báo
      rethrow;
    }
  }
}

// Provider cho UserProfileNotifier
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repository);
});
