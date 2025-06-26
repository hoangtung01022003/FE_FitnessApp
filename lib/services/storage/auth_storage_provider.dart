import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/services/storage/auth_storage_service.dart';

/// Provider để truy cập AuthStorageService từ bất kỳ đâu trong ứng dụng
final authStorageProvider = Provider<AuthStorageService>((ref) {
  return AuthStorageService();
});
