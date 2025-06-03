import 'package:flutter/material.dart';

class TappableDotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final void Function(int) onTap;

  const TappableDotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index ? Colors.orange : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
