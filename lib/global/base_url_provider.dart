import 'package:flutter_riverpod/flutter_riverpod.dart';

// Base URL for the API
final baseUrlProvider = Provider<String>((ref) {
  return 'http://localhost:8000/api'; // Replace with your actual base URL
});
