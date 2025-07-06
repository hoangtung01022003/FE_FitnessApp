import 'package:finess_app/global/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/global/custom_bottom_nav_bar.dart';

class ExercisePage extends HookConsumerWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng hooks để tạo các animation controller
    final tabController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    // Animation cho tab selection
    final tabAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: tabController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Theo dõi tab đang được chọn
    final selectedCategoryState = useState('Full body');

    // Danh sách category cố định
    final categories = ['Full body', 'Foot', 'Arm', 'Body'];

    // Sử dụng hook để tạo ScrollController
    final scrollController = useScrollController();

    // Sử dụng hook để tạo hiệu ứng khi cuộn
    final scrollOffset = useState(0.0);

    // Lắng nghe sự kiện cuộn và cập nhật offset
    useEffect(() {
      void listener() {
        scrollOffset.value = scrollController.offset;
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    // Tính toán index của tab được chọn
    final selectedIndex = categories.indexOf(selectedCategoryState.value);
    final previousSelectedIndex = useRef<int>(selectedIndex);

    // Trigger animation khi tab thay đổi
    useEffect(() {
      if (previousSelectedIndex.value != selectedIndex) {
        tabController.forward(from: 0.0);
        previousSelectedIndex.value = selectedIndex;
      }
      return null;
    }, [selectedIndex]);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBar(
                    title: 'Exercises',
                    showBack: true,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 10),

                  // Tabs with evenly divided space
                  SizedBox(
                    height: 40,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tabWidth =
                            constraints.maxWidth / categories.length;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                selectedCategoryState.value == category;

                            return GestureDetector(
                              onTap: () {
                                selectedCategoryState.value = category;
                              },
                              child: Container(
                                width: tabWidth,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: isSelected ? 2 * tabAnimation : 0,
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Workout List with scroll controller
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        // Tính toán offset cho hiệu ứng hiển thị khi cuộn
                        final itemPosition = index * 100.0;
                        final visible = scrollOffset.value < itemPosition + 200;

                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: visible ? 1.0 : 0.3,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Workout',
                                    style: TextStyle(color: Colors.orange)),
                                const SizedBox(height: 8),
                                const Text(
                                  'Climbers',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Personalized workouts will help',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'See',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
