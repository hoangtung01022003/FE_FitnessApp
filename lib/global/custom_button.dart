import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width; // Thêm tham số width

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width, // Thêm tham số này vào constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          double
              .infinity, // Sử dụng width nếu được cung cấp, nếu không thì dùng double.infinity
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              onPressed == null ? Colors.grey : Colors.orangeAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
