import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tạo class state để lưu trữ trạng thái
class HomeState {
  // Thêm các thuộc tính trạng thái nếu cần

  const HomeState();

  // Phương thức để cập nhật trạng thái nếu cần
  HomeState copyWith() {
    return const HomeState();
  }
}

// Chuyển đổi từ ChangeNotifierProvider sang StateNotifierProvider
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel());

// Chuyển đổi từ ChangeNotifier sang StateNotifier
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());

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
