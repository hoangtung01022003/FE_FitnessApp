import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderSelected;
  final bool showError;
  final String? errorMessage;

  const GenderSelector({
    Key? key,
    required this.selectedGender,
    required this.onGenderSelected,
    this.showError = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Gender',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showError && errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  context,
                  'Male', // Changed from 'male' to 'Male'
                  Icons.male,
                  'Male',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption(
                  context,
                  'Female', // Changed from 'female' to 'Female'
                  Icons.female,
                  'Female',
                  Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String gender,
    IconData icon,
    String label,
    Color color,
  ) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => onGenderSelected(gender),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? color
                : showError && selectedGender == null
                    ? Colors.red
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
