import 'package:finess_app/global/gender_button.dart';
import 'package:finess_app/global/pesonal_detail_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';
import 'package:finess_app/global/custom_button.dart';
import 'package:finess_app/global/tappable_dot_indicator.dart';


class Step3PersonalDetails extends ConsumerWidget {
  const Step3PersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(welcomeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
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
                  
                  // Use the new FieldWidget
                  PesonalDetailField(label: "Birthday", value: "Aug 25, 1990"),
                  SizedBox(height: 8),
                  PesonalDetailField(label: "Height", value: "175 cm"),
                  SizedBox(height: 8),
                  PesonalDetailField(label: "Weight", value: "75 kg"),
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          GenderButton(gender: "Male"),
                          GenderButton(gender: "Female"),
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
