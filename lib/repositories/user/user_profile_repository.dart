import 'package:dio/dio.dart';
import 'package:finess_app/models/user/user_profile.dart';
import 'package:finess_app/repositories/user/user_profile_repository_interface.dart';

class UserProfileRepository implements IUserProfileRepository {
  final Dio _dio;

  UserProfileRepository(this._dio);

  @override
  Future<UserProfile> createProfile(UserProfile profile) async {
    try {
      print('Before API call: ${profile.toJson()}');
      final response = await _dio.post('/profile', data: profile.toJson());
      print('API response: ${response.data}');
      return UserProfile.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final response = await _dio.put(
        '/profile',
        data: profile.toJson(),
      );
      return UserProfile.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserProfile?> getProfile() async {
    try {
      final response = await _dio.get('/profile');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserProfile.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
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
