class ExerciseModel {
  final String exerciseId;
  final String name;
  final String gifUrl;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> instructions;

  ExerciseModel({
    required this.exerciseId,
    required this.name,
    required this.gifUrl,
    required this.targetMuscles,
    required this.bodyParts,
    required this.equipments,
    required this.instructions,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json['exerciseId'] ?? '',
      name: json['name'] ?? '',
      gifUrl: json['gifUrl'] ?? '',
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      bodyParts: List<String>.from(json['bodyParts'] ?? []),
      equipments: List<String>.from(json['equipments'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'gifUrl': gifUrl,
      'targetMuscles': targetMuscles,
      'bodyParts': bodyParts,
      'equipments': equipments,
      'instructions': instructions,
    };
  }
}

class ExerciseResponse {
  final bool success;
  final ExerciseMetadata metadata;
  final List<ExerciseModel> data;

  ExerciseResponse({
    required this.success,
    required this.metadata,
    required this.data,
  });

  factory ExerciseResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseResponse(
      success: json['success'] ?? false,
      metadata: ExerciseMetadata.fromJson(json['metadata'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((item) => ExerciseModel.fromJson(item))
          .toList(),
    );
  }
}

class ExerciseMetadata {
  final int totalExercises;
  final int currentPage;

  ExerciseMetadata({
    required this.totalExercises,
    required this.currentPage,
  });

  factory ExerciseMetadata.fromJson(Map<String, dynamic> json) {
    return ExerciseMetadata(
      totalExercises: json['totalExercises'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}

class WorkoutPlan {
  final String title;
  final String week;
  final List<WorkoutExercise> exercises;

  WorkoutPlan({
    required this.title,
    required this.week,
    required this.exercises,
  });
}

class WorkoutExercise {
  final ExerciseModel exercise;
  final String duration;
  final int sets;
  final int reps;
  final bool isCompleted;

  WorkoutExercise({
    required this.exercise,
    required this.duration,
    required this.sets,
    required this.reps,
    this.isCompleted = false,
  });

  WorkoutExercise copyWith({
    ExerciseModel? exercise,
    String? duration,
    int? sets,
    int? reps,
    bool? isCompleted,
  }) {
    return WorkoutExercise(
      exercise: exercise ?? this.exercise,
      duration: duration ?? this.duration,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
