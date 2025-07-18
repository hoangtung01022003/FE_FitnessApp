import 'package:dio/dio.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';

/// ExerciseDB API (https://exercisedb-api.vercel.app)
/// Free and open API for fitness exercises with GIFs and metadata.
class ExerciseDBService {
  final Dio _dio;
  final String baseUrl = 'https://hoangtung01022003.vercel.app';

  ExerciseDBService() : _dio = Dio();

  /// Fetch all exercises
  Future<List<ExerciseModel>> fetchAllExercises() async {
    try {
      final response = await _dio.get('$baseUrl/exercises');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises: ${e.message}');
    }
  }

  /// Fetch exercises by body part (e.g. "chest", "legs", "back")
  Future<List<ExerciseModel>> fetchByBodyPart(String part) async {
    try {
      final response = await _dio.get('$baseUrl/exercises/bodyPart/$part');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by body part');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by body part: ${e.message}');
    }
  }

  /// Fetch exercises by target muscle (e.g. "abs", "quads")
  Future<List<ExerciseModel>> fetchByTarget(String target) async {
    try {
      final response = await _dio.get('$baseUrl/exercises/target/$target');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by target');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by target: ${e.message}');
    }
  }

  /// Fetch exercises by equipment (e.g. "dumbbell", "barbell", "body weight")
  Future<List<ExerciseModel>> fetchByEquipment(String equipment) async {
    try {
      final response =
          await _dio.get('$baseUrl/exercises/equipment/$equipment');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch exercises by equipment');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises by equipment: ${e.message}');
    }
  }
}
