import 'package:flutter/material.dart';

class StepText extends StatelessWidget {
  final String title;

  const StepText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.orange, fontSize: 20),
              ),
            ),
          ),// Placeholder to balance back button
        ],
      ),
    );
  }
}
