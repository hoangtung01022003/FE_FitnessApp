import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/auth/profile_page.dart';

final menuViewModelProvider = ChangeNotifierProvider((ref) => MenuViewModel());

class MenuItem {
  final String title;
  final IconData icon;
  final Color? color;

  MenuItem({required this.title, required this.icon, this.color});
}

class MenuViewModel extends ChangeNotifier {
  String _selectedItem = 'Running';

  String get selectedItem => _selectedItem;

  void selectItem(String item) {
    _selectedItem = item;
    notifyListeners();
  }

  bool isSelected(String item) => _selectedItem == item;
  
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
}
