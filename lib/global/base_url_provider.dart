import 'package:flutter_riverpod/flutter_riverpod.dart';

// Base URL for the API
final baseUrlProvider = Provider<String>((ref) {
  return 'http://172.20.192.1:8000/api/'; // Updated for local Docker development
});
