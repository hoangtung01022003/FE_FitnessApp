import 'package:flutter_riverpod/flutter_riverpod.dart';

// Base URL for the API
final baseUrlProvider = Provider<String>((ref) {
  return 'https://docker-be-fitnessapp-production.up.railway.app/api'; // Replace with your actual base URL
});
