import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/routes/router.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Color? color;

  MenuItem({required this.title, required this.icon, this.color});
}

// Tạo class state để lưu trữ trạng thái
class MenuState {
  final String selectedItem;

  const MenuState({
    this.selectedItem = 'Running',
  });

  // Phương thức để tạo một state mới dựa trên state hiện tại
  MenuState copyWith({
    String? selectedItem,
  }) {
    return MenuState(
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}

// Chuyển đổi từ ChangeNotifierProvider sang StateNotifierProvider
final menuViewModelProvider = StateNotifierProvider<MenuViewModel, MenuState>(
    (ref) => MenuViewModel(ref: ref));

// Chuyển đổi từ ChangeNotifier sang StateNotifier
class MenuViewModel extends StateNotifier<MenuState> {
  final Ref? _ref; // Thay đổi kiểu từ Ref sang Ref?

  MenuViewModel({Ref? ref})
      : _ref = ref,
        super(const MenuState());

  void selectItem(String item) {
    state = state.copyWith(selectedItem: item);
  }

  bool isSelected(String item) => state.selectedItem == item;

  List<String> get drawerItems => [
        'Running',
        'Yoga',
        'Workout',
        'Walking',
        'Fitness',
        'Strength',
      ];

  List<IconData> get drawerIcons => [
        Icons.directions_run,
        Icons.self_improvement,
        Icons.fitness_center,
        Icons.directions_walk,
        Icons.sports_gymnastics,
        Icons.sports_mma,
      ];

  final List<MenuItem> menuItems = [
    MenuItem(title: 'Home', icon: Icons.home, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Weight', icon: Icons.monitor_weight, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Training plan', icon: Icons.fitness_center, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Training Stats', icon: Icons.bar_chart, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Meal Plan', icon: Icons.restaurant, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Schedule', icon: Icons.schedule, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Exercises', icon: Icons.directions_run, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Tips', icon: Icons.lightbulb, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Settings', icon: Icons.settings, color: const Color(0xFFFF9B70)),
    MenuItem(title: 'Support', icon: Icons.support_agent, color: const Color(0xFFFF9B70)),
  ];

  // Thêm phương thức đăng xuất
  Future<void> logout(BuildContext context) async {
    try {
      await _ref?.read(authNotifierProvider.notifier).logout();

      // Điều hướng về màn hình đăng nhập sau khi đăng xuất
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
      }
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
    }
  }
}
