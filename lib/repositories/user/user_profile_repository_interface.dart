import 'package:finess_app/models/user/user_profile.dart';

abstract class IUserProfileRepository {
  Future<UserProfile> createProfile(UserProfile profile);
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<UserProfile?> getProfile();
}