import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finess_app/viewModels/welcome/welcome_view_model.dart';

class PesonalDetailField extends StatelessWidget {
  final String label;
  final String? value;

  const PesonalDetailField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return buildField(label, value ?? '');
  }

  Widget buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: Colors.deepOrange)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}