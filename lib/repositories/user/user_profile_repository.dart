import 'package:dio/dio.dart';
import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/repositories/user/user_profile_repository_interface.dart';

class UserProfileRepository implements IUserProfileRepository {
  final Dio _dio;

  UserProfileRepository(this._dio);

  @override
  Future<UserProfile> createProfile(UserProfile profile) async {
    try {
      // Log trước khi gửi request
      print('Creating profile with data: ${profile.toJson()}');

      // Đảm bảo đã có đầy đủ thông tin cần thiết
      final data = profile.toJson();

      // Gọi API tạo profile
      final response = await _dio.post('/profile', data: data);

      // Log phản hồi từ server
      print('Profile created successfully. Server response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfile.fromJson(response.data['profile']);
      } else {
        throw Exception(
            'Failed to create profile: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException while creating profile: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status code: ${e.response?.statusCode}');
      throw _handleError(e);
    } catch (e) {
      print('Unexpected error while creating profile: $e');
      throw Exception('Không thể tạo hồ sơ: $e');
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      // Log trước khi gửi request
      print('Updating profile with data: ${profile.toJson()}');

      // Đảm bảo đã có đầy đủ thông tin cần thiết
      final data = profile.toJson();

      // Gọi API cập nhật profile
      final response = await _dio.put('/profile', data: data);

      // Log phản hồi từ server
      print('Profile updated successfully. Server response: ${response.data}');

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw Exception(
            'Failed to update profile: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException while updating profile: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status code: ${e.response?.statusCode}');
      throw _handleError(e);
    } catch (e) {
      print('Unexpected error while updating profile: $e');
      throw Exception('Không thể cập nhật hồ sơ: $e');
    }
  }

  @override
  Future<UserProfile?> getProfile() async {
    try {
      print('Fetching user profile...');
      final response = await _dio.get('/profile');
      print('Profile response received: ${response.statusCode}');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserProfile.fromJson(response.data['data']);
      }
      print('Profile response did not contain valid data: ${response.data}');
      return null;
    } on DioException catch (e) {
      print('DioException while fetching profile: ${e.message}');
      print('DioException type: ${e.type}');
      print('Response data: ${e.response?.data}');
      print('Response status code: ${e.response?.statusCode}');
      throw _handleError(e);
    } catch (e) {
      print('Unexpected error while fetching profile: $e');
      throw Exception('Không thể tải hồ sơ: $e');
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('error')) {
          return Exception(data['error']);
        }
        if (data.containsKey('message')) {
          return Exception(data['message']);
        }
      }
    }
    return Exception('Đã xảy ra lỗi khi kết nối với máy chủ');
  }
}
