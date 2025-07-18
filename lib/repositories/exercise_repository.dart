import 'package:finess_app/models/exercise/exercise_model.dart';
import 'package:finess_app/services/exercise_api_service.dart';

class ExerciseRepository {
  final ExerciseApiService _apiService = ExerciseApiService();

  // Lấy tất cả các body parts từ API
  Future<List<String>> getAllBodyParts() async {
    return await _apiService.getAllBodyParts();
  }

  // Lấy tất cả các equipment từ API
  Future<List<String>> getAllEquipments() async {
    return await _apiService.getAllEquipments();
  }

  // Lấy tất cả các target muscles từ API
  Future<List<String>> getAllTargetMuscles() async {
    return await _apiService.getAllTargetMuscles();
  }

  Future<List<ExerciseModel>> getAllExercises({int page = 1}) async {
    final response = await _apiService.getAllExercises(page: page);
    return response.data;
  }

  Future<List<ExerciseModel>> searchExercises(String query) async {
    final response = await _apiService.searchExercises(query);
    return response.data;
  }

  Future<List<ExerciseModel>> filterExercises({
    String? bodyPart,
    String? equipment,
    String? muscle,
  }) async {
    final response = await _apiService.filterExercises(
      bodyPart: bodyPart,
      equipment: equipment,
      muscle: muscle,
    );
    return response.data;
  }

  Future<ExerciseModel> getExerciseById(String exerciseId) async {
    return await _apiService.getExerciseById(exerciseId);
  }

  Future<List<ExerciseModel>> getExercisesByBodyPart(
      String bodyPartName) async {
    final response = await _apiService.getExercisesByBodyPart(bodyPartName);
    return response.data;
  }

  Future<List<ExerciseModel>> getExercisesByEquipment(
      String equipmentName) async {
    final response = await _apiService.getExercisesByEquipment(equipmentName);
    return response.data;
  }

  Future<List<ExerciseModel>> getExercisesByMuscle(String muscleName) async {
    final response = await _apiService.getExercisesByMuscle(muscleName);
    return response.data;
  }

  // Tạo một kế hoạch tập luyện mẫu (trong thực tế có thể lấy từ API hoặc database)
  Future<WorkoutPlan> getTodayWorkoutPlan() async {
    final exercises = await getAllExercises(page: 1);

    if (exercises.isEmpty) {
      throw Exception('Không có bài tập nào khả dụng');
    }

    // Chọn 3 bài tập đầu tiên để làm mẫu
    final workoutExercises = exercises
        .take(3)
        .map((exercise) => WorkoutExercise(
              exercise: exercise,
              duration: '${5 + exercises.indexOf(exercise) * 2} phút',
              sets: 3,
              reps: 12,
            ))
        .toList();

    return WorkoutPlan(
      title: 'Training session today',
      week: 'Week 1',
      exercises: workoutExercises,
    );
  }
}
