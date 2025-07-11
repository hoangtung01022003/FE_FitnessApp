import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/views/auth/welcome/step1_welcome.dart';
import 'package:finess_app/views/auth/welcome/step2_fitness_level.dart';
import 'package:finess_app/views/auth/welcome/step3_personal_details.dart';

class Welcome extends HookConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng hooks để theo dõi lifecycle và animation
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    // Sử dụng hook để tạo animation cho chuyển trang
    final pageAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Lắng nghe thay đổi trang và trigger animation
    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    // Tách biệt state và notifier theo mô hình MVVM
    final state = ref.watch(welcomeViewModelProvider);
    final viewModelNotifier = ref.read(welcomeViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Sử dụng AnimatedOpacity để tạo hiệu ứng fade-in
            AnimatedOpacity(
              opacity: pageAnimation,
              duration: const Duration(milliseconds: 300),
              child: PageView(
                controller: state.pageController,
                onPageChanged: viewModelNotifier.onPageChanged,
                children: const [
                  Step1Welcome(),
                  Step2FitnessLevel(),
                  Step3PersonalDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
