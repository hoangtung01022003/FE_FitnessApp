import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/auth/profile_page.dart';

final menuViewModelProvider = ChangeNotifierProvider((ref) => MenuViewModel());

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
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
}
