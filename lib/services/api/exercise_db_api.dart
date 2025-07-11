import 'dart:convert';
import 'package:dio/dio.dart';

/// ExerciseDB API (https://exercisedb-api.vercel.app)
/// Free and open API for fitness exercises with GIFs and metadata.
///
/// Example usage:
///   - Fetch all exercises
///   - Filter by body part, equipment, or target muscle

const String baseUrl = 'https://exercisedb-api.vercel.app';

/// Exercise model
class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final String gifUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.gifUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      bodyPart: json['bodyPart'],
      equipment: json['equipment'],
      target: json['target'],
      gifUrl: json['gifUrl'],
    );
  }
}

/// ExerciseDBService class for API calls
class ExerciseDBService {
  final Dio _dio;

  ExerciseDBService() : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  /// Fetch all exercises
  Future<List<Exercise>> fetchAllExercises() async {
    try {
      final response = await _dio.get('/exercises');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Exercise.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises: ${e.message}');
    }
  }

  /// Fetch exercises by body part (e.g. "chest", "legs", "back")
  Future<List<Exercise>> fetchByBodyPart(String part) async {
    try {
      final response = await _dio.get('/exercises/bodyPart/$part');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Exercise.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by body part');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by body part: ${e.message}');
    }
  }

  /// Fetch exercises by target muscle (e.g. "abs", "quads")
  Future<List<Exercise>> fetchByTarget(String target) async {
    try {
      final response = await _dio.get('/exercises/target/$target');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Exercise.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by target');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by target: ${e.message}');
    }
  }

  /// Fetch exercises by equipment (e.g. "dumbbell", "barbell", "body weight")
  Future<List<Exercise>> fetchByEquipment(String equipment) async {
    try {
      final response = await _dio.get('/exercises/equipment/$equipment');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Exercise.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by equipment');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by equipment: ${e.message}');
    }
  }
}
