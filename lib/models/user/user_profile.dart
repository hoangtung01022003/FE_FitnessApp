class UserProfile {
  final int? id;
  final int? userId; // Thêm trường user_id
  final String? fitnessLevel;
  final DateTime? birthday;
  final double? height;
  final double? weight;
  final String? gender;

  UserProfile({
    this.id,
    this.userId, // Thêm vào constructor
    this.fitnessLevel,
    this.birthday,
    this.height,
    this.weight,
    this.gender,
    // DateTime? birthdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId, // Thêm vào JSON
      'fitness_level': fitnessLevel,
      'birthday': birthday?.toIso8601String(),
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'], // Trích xuất từ JSON
      fitnessLevel: json['fitness_level'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      height: json['height'] != null
          ? double.parse(json['height'].toString())
          : null,
      weight: json['weight'] != null
          ? double.parse(json['weight'].toString())
          : null,
      gender: json['gender'],
    );
  }
}
