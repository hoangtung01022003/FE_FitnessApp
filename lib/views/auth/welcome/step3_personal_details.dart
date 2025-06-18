import 'package:finess_app/global/gender_button.dart';
import 'package:finess_app/global/pesonal_detail_field.dart';
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
    final viewModel = ref.read(welcomeViewModelProvider);
    final DateTime now = DateTime.now();
    final DateTime initialDate = viewModel.selectedBirthday ??
        DateTime(now.year - 18, now.month, now.day);

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
        viewModel.setBirthday(now);
      } else {
        viewModel.setBirthday(picked);
      }
      setState(() {}); // Cập nhật UI
    }
  }

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(welcomeViewModelProvider);
    if (viewModel.height != null) {
      _heightController.text = viewModel.height!.toStringAsFixed(0);
    }
    if (viewModel.weight != null) {
      _weightController.text = viewModel.weight!.toStringAsFixed(0);
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
    final viewModel = ref.read(welcomeViewModelProvider);
    String birthdayText = viewModel.selectedBirthday != null
        ? DateFormat('MMM dd, yyyy').format(viewModel.selectedBirthday!)
        : "Select your birthday";

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Step 3 of 3",
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to\nFitness Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Personalized workouts will help you gain strength, get in better shape and embrace a healthy lifestyle",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 32),

                  // Date picker field
                  PesonalDetailField(
                    label: "Birthday",
                    value: birthdayText,
                    onTap: () => _selectDate(context),
                  ),

                  SizedBox(height: 8),
                  PesonalDetailField(
                    label: "Height",
                    value: "",
                    suffix: "cm",
                    useTextField: true,
                    controller: _heightController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        viewModel.setHeight(double.tryParse(value) ?? 0);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  PesonalDetailField(
                    label: "Weight",
                    value: "",
                    suffix: "kg",
                    useTextField: true,
                    controller: _weightController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        viewModel.setWeight(double.tryParse(value) ?? 0);
                      }
                    },
                  ),
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          GenderButton(
                            gender: "Male",
                            isSelected: viewModel.selectedGender == "Male",
                            onTap: () => viewModel.selectGender("Male"),
                          ),
                          GenderButton(
                            gender: "Female",
                            isSelected: viewModel.selectedGender == "Female",
                            onTap: () => viewModel.selectGender("Female"),
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
                onPressed: () {
                  // You can handle button press here, maybe print selectedGender etc.
                  print('Selected Gender: ${viewModel.selectedGender}');
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
                onTap: viewModel.goToPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
