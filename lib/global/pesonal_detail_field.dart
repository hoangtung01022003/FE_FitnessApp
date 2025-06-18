import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PesonalDetailField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool useTextField;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? suffix;

  const PesonalDetailField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.useTextField = false,
    this.controller,
    this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (useTextField)
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.deepOrange),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: suffix,
                      suffixText: suffix,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: onChanged,
                  ),
                )
              else
                Text(value, style: const TextStyle(color: Colors.deepOrange)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
