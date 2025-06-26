import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const HeaderBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.backgroundColor = Colors.orangeAccent,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: iconColor),
                onPressed: onBack ?? () => Navigator.pop(context),
              ),
            ),
          Center(
            child: Text(
              title,
              style: TextStyle(color: textColor, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
