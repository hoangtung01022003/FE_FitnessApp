import 'package:flutter_riverpod/flutter_riverpod.dart';

// Base URL for the API
final baseUrlProvider = Provider<String>((ref) {
  // Railway URL - Lưu ý: Đảm bảo Railway được cấu hình đúng với MySQL
  // Nếu xuất hiện lỗi "hiện tại đang sử dụng: sqlite", kiểm tra các biến môi trường sau trong Railway:
  // - MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD
  // - Đảm bảo MySQL addon đã được thêm và liên kết với dịch vụ Docker
  return 'https://docker-be-fitnessapp-production.up.railway.app/api'; // Replace with your actual base URL
});
