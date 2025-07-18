import 'package:flutter/material.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/models/exercise/exercise_model.dart';
import 'package:finess_app/utils/image_helper.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailPage({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            HeaderBar(title: exercise.name),

            // Main content - scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise image/animation
                    Center(
                      child: Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade200,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ImageHelper.networkImageWithProxy(
                          imageUrl: exercise.gifUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Target muscles
                    if (exercise.targetMuscles.isNotEmpty)
                      _buildInfoSection(
                          'Target Muscles', exercise.targetMuscles.join(', ')),

                    // Equipment needed
                    if (exercise.equipments.isNotEmpty)
                      _buildInfoSection(
                          'Equipment', exercise.equipments.join(', ')),

                    // Body parts
                    if (exercise.bodyParts.isNotEmpty)
                      _buildInfoSection(
                          'Body Part', exercise.bodyParts.join(', ')),

                    // Instructions (if available)
                    if (exercise.instructions.isNotEmpty)
                      _buildListSection(
                        'Instructions',
                        exercise.instructions,
                        ordered: true,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display a single info item with icon
  Widget _buildInfoSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _getIconForCategory(title),
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Widget to display a list of items (instructions or muscles)
  Widget _buildListSection(String title, List<String> items,
      {bool ordered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: ordered ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: ordered ? null : BorderRadius.circular(4),
                  ),
                  child: Text(
                    ordered ? '${index + 1}' : '•',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper to get an appropriate icon based on the section title
  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'target muscles':
        return Icons.fitness_center;
      case 'equipment':
        return Icons.sports_gymnastics;
      case 'body part':
        return Icons.accessibility_new;
      default:
        return Icons.info_outline;
    }
  }
}
