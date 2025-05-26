import 'package:flutter_riverpod/flutter_riverpod.dart';

// Base URL for the API
final baseUrlProvider = Provider<String>((ref) {
  return 'http://127.0.0.1:8000/api'; // Replace with your actual base URL
});
