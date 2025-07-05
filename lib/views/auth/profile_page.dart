import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/global/header_bar.dart';
import 'package:finess_app/global/custom_bottom_nav_bar.dart';
import 'package:finess_app/global/gender_button.dart';
import 'package:finess_app/global/pesonal_detail_field.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Thêm state để lưu giới tính được chọn
  String? selectedGender = "Male"; // Mặc định chọn Nam

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderBar(
              title: 'Profile',
              showBack: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    const PesonalDetailField(
                        label: "Birthday", value: "Aug 25, 1990"),
                    const SizedBox(height: 8),
                    const PesonalDetailField(label: "Height", value: "175 cm"),
                    const SizedBox(height: 8),
                    const PesonalDetailField(label: "Weight", value: "75 kg"),
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
                              isSelected: selectedGender == "Male",
                              onTap: () =>
                                  setState(() => selectedGender = "Male"),
                            ),
                            GenderButton(
                              gender: "Female",
                              isSelected: selectedGender == "Female",
                              onTap: () =>
                                  setState(() => selectedGender = "Female"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Fitness Level",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Beginer",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                    const Divider(height: 32),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Manage My Data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    GestureDetector(
                      onTap: () {
                        // handle restart basic plan
                      },
                      child: const Text(
                        "Restart Basic Plan",
                        style:
                            TextStyle(color: Color(0xFFFF9B6A), fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // handle restone subscription
                      },
                      child: const Text(
                        "Restone Subscription",
                        style:
                            TextStyle(color: Color(0xFFFF9B6A), fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // handle bottom nav tap
        },
      ),
    );
  }
}
