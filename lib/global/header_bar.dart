import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const HeaderBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orangeAccent,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack ?? () => Navigator.pop(context),
            ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          if (showBack) const SizedBox(width: 48), // Placeholder to balance back button
        ],
      ),
    );
  }
}
