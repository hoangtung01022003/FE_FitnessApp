import 'package:finess_app/views/auth/home_page.dart';
import 'package:finess_app/views/auth/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewModels/menu_view_model.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tách biệt state và notifier theo mô hình MVVM
    final state = ref.watch(menuViewModelProvider);
    final viewModelNotifier = ref.read(menuViewModelProvider.notifier);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const ListTile(
              leading: CircleAvatar(),
              title: Text('User'),
              trailing: Icon(
                Icons.menu,
                color: Colors.red,
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.directions_run),
              title: Text('Running'),
            ),
            const ListTile(
              leading: Icon(Icons.self_improvement),
              title: Text('Yoga'),
              trailing: Icon(Icons.info_outline),
            ),
            const ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Workout'),
            ),
            const ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text('Walking'),
            ),
            const ListTile(
              leading: Icon(Icons.sports_mma),
              title: Text('Fitness'),
              trailing: Icon(Icons.info_outline),
            ),
            const ListTile(
              leading: Icon(Icons.sports_handball),
              title: Text('Strength'),
            ),
            const Divider(),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Hiển thị dialog xác nhận trước khi đăng xuất
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận đăng xuất'),
                    content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          viewModelNotifier.logout(context);
                        },
                        child: const Text('Đăng xuất'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D8D8D),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF8D8D8D),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.white),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfilePage()),
                        );
                      },
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: viewModelNotifier.menuItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    // Handle item tap
                    if (item.title == 'Home') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: const Icon(Icons.home,
                                color: Colors.red, size: 40),
                            // const SizedBox(height: 8),
                            //Text(item.title, textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
