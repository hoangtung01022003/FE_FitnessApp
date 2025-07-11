import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finess_app/viewModels/home/home_state.dart';

// Chuyển đổi từ ChangeNotifierProvider sang StateNotifierProvider với freezed state
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel());

// Chuyển đổi từ ChangeNotifier sang StateNotifier với freezed state
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());

  // Có thể thêm các phương thức để thay đổi state ở đây
  void updateSelectedWorkout(String workout) {
    state = state.copyWith(selectedWorkout: workout);
  }

  Widget buildExerciseRow({
    required IconData icon,
    required String label,
    required String time,
    required Color iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        const Icon(Icons.info_outline, color: Colors.grey),
      ],
    );
  }
}
