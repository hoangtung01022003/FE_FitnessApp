import 'package:finess_app/global/gender_button.dart';
import 'package:finess_app/global/pesonal_detail_field.dart';
import 'package:finess_app/views/auth/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';
import 'package:intl/intl.dart';

class Step3PersonalDetails extends ConsumerStatefulWidget {
  const Step3PersonalDetails({super.key});

  @override
  ConsumerState<Step3PersonalDetails> createState() =>
      _Step3PersonalDetailsState();
}

class _Step3PersonalDetailsState extends ConsumerState<Step3PersonalDetails> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    // Tách biệt notifier và state theo mô hình MVVM
    final viewModelNotifier = ref.read(welcomeViewModelProvider.notifier);
    final state = ref.read(welcomeViewModelProvider);

    final DateTime now = DateTime.now();
    final DateTime initialDate =
        state.selectedBirthday ?? DateTime(now.year - 18, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Nếu chọn ngày trong tương lai, reset về ngày hiện tại
      if (picked.isAfter(now)) {
        viewModelNotifier.setBirthday(now);
      } else {
        viewModelNotifier.setBirthday(picked);
      }
      setState(() {}); // Cập nhật UI
    }
  }

  @override
  void initState() {
    super.initState();
    // Đọc state từ provider
    final state = ref.read(welcomeViewModelProvider);

    if (state.height != null) {
      _heightController.text = state.height!.toStringAsFixed(0);
    }
    if (state.weight != null) {
      _weightController.text = state.weight!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tách biệt notifier và state theo mô hình MVVM
    final viewModelNotifier = ref.read(welcomeViewModelProvider.notifier);
    final state = ref.watch(welcomeViewModelProvider);

    String birthdayText = state.selectedBirthday != null
        ? DateFormat('MMM dd, yyyy').format(state.selectedBirthday!)
        : "Select your birthday";

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Step 3 of 3",
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome to\nFitness Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Personalized workouts will help you gain strength, get in better shape and embrace a healthy lifestyle",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Date picker field
                  PesonalDetailField(
                    label: "Birthday",
                    value: birthdayText,
                    onTap: () => _selectDate(context),
                  ),

                  const SizedBox(height: 8),
                  PesonalDetailField(
                    label: "Height",
                    value: "",
                    suffix: "cm",
                    useTextField: true,
                    controller: _heightController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        viewModelNotifier
                            .setHeight(double.tryParse(value) ?? 0);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  PesonalDetailField(
                    label: "Weight",
                    value: "",
                    suffix: "kg",
                    useTextField: true,
                    controller: _weightController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        viewModelNotifier
                            .setWeight(double.tryParse(value) ?? 0);
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          GenderButton(
                            gender: "Male",
                            isSelected: state.selectedGender == "Male",
                            onTap: () => viewModelNotifier.selectGender("Male"),
                          ),
                          GenderButton(
                            gender: "Female",
                            isSelected: state.selectedGender == "Female",
                            onTap: () =>
                                viewModelNotifier.selectGender("Female"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: CustomButton(
                label: 'Get Started',
                onPressed: () async {
                  final viewModelNotifier =
                      ref.read(welcomeViewModelProvider.notifier);
                  final success = viewModelNotifier.saveProfile();

                  if (await success) {
                    // Navigate to the main app screen or dashboard
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MenuPage(),
                      ),
                    );
                  } else {
                    // Show error message if profile validation failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            ref.read(welcomeViewModelProvider).errorMessage ??
                                'Please fill in all required fields correctly'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: TappableDotIndicator(
                currentIndex: 2,
                totalDots: 3,
                onTap: viewModelNotifier.goToPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
