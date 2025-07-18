import 'package:dio/dio.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';

class ExerciseApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://hoangtung01022003.vercel.app/api/v1',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // API để lấy danh sách các body parts
  Future<List<String>> getAllBodyParts() async {
    try {
      final response = await _dio.get('/bodyparts');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((item) => item.toString()).toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách body parts: $e');
    }
  }

  // API để lấy danh sách các equipments
  Future<List<String>> getAllEquipments() async {
    try {
      final response = await _dio.get('/equipments');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((item) => item.toString()).toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách equipments: $e');
    }
  }

  // API để lấy danh sách các target muscles
  Future<List<String>> getAllTargetMuscles() async {
    try {
      final response = await _dio.get('/muscles');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((item) => item.toString()).toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách target muscles: $e');
    }
  }

  Future<ExerciseResponse> getAllExercises({int page = 1}) async {
    try {
      final response =
          await _dio.get('/exercises', queryParameters: {'page': page});
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể tải danh sách bài tập: $e');
    }
  }

  Future<ExerciseResponse> searchExercises(String query) async {
    try {
      final response =
          await _dio.get('/exercises/search', queryParameters: {'name': query});
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể tìm kiếm bài tập: $e');
    }
  }

  Future<ExerciseResponse> filterExercises({
    String? bodyPart,
    String? equipment,
    String? muscle,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (bodyPart != null) queryParams['bodyPart'] = bodyPart;
      if (equipment != null) queryParams['equipment'] = equipment;
      if (muscle != null) queryParams['muscle'] = muscle;

      final response =
          await _dio.get('/exercises/filter', queryParameters: queryParams);
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể lọc bài tập: $e');
    }
  }

  Future<ExerciseModel> getExerciseById(String exerciseId) async {
    try {
      final response = await _dio.get('/exercises/$exerciseId');
      return ExerciseModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Không thể lấy thông tin bài tập: $e');
    }
  }

  Future<ExerciseResponse> getExercisesByBodyPart(String bodyPartName) async {
    try {
      final response = await _dio.get('/bodyparts/$bodyPartName/exercises');
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể lấy bài tập cho phần cơ thể: $e');
    }
  }

  Future<ExerciseResponse> getExercisesByEquipment(String equipmentName) async {
    try {
      final response = await _dio.get('/equipments/$equipmentName/exercises');
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể lấy bài tập cho thiết bị: $e');
    }
  }

  Future<ExerciseResponse> getExercisesByMuscle(String muscleName) async {
    try {
      final response = await _dio.get('/muscles/$muscleName/exercises');
      return ExerciseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể lấy bài tập cho nhóm cơ: $e');
    }
  }
}
