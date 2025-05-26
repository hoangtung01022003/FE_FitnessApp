import 'package:finess_app/models/api/auth_response.dart';

abstract class IAuthRepository {
  Future<AuthResponse> register(String username, String email, String password);
  Future<AuthResponse> login(String email, String password);
  Future<void> logout(String token);
}

// DAO NGUOC SU PHU THUOC // CLEAN ARCHITECTURE
