import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/routes/router.dart';
import 'package:finess_app/viewModels/auth/auth_providers.dart';

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
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
    MenuItem(title: 'Home', icon: Icons.home),
    MenuItem(title: 'Weight', icon: Icons.monitor_weight),
    MenuItem(title: 'Training plan', icon: Icons.fitness_center),
    MenuItem(title: 'Training Stats', icon: Icons.bar_chart),
    MenuItem(title: 'Meal Plan', icon: Icons.restaurant),
    MenuItem(title: 'Schedule', icon: Icons.schedule),
    MenuItem(title: 'Exercises', icon: Icons.directions_run),
    MenuItem(title: 'Tips', icon: Icons.lightbulb),
    MenuItem(title: 'Settings', icon: Icons.settings),
    MenuItem(title: 'Support', icon: Icons.support_agent),
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
