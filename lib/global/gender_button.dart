import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';

class GenderButton extends ConsumerWidget {
  final String gender;

  const GenderButton({super.key, required this.gender});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(welcomeViewModelProvider);
    final isSelected = viewModel.selectedGender == gender;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.orange : Colors.transparent,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () => ref.read(welcomeViewModelProvider.notifier).selectGender(gender),
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
