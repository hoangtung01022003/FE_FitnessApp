import 'package:finess_app/global/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerField extends StatelessWidget {
  final String label;
  final String? suffix;
  final double? value;
  final Function(double) onValueSelected;
  final bool isError;
  final String? errorMessage;
  final int minValue;
  final int maxValue;
  final int step;
  final IconData icon;

  const NumberPickerField({
    super.key,
    required this.label,
    this.suffix,
    required this.value,
    required this.onValueSelected,
    this.isError = false,
    this.errorMessage,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    required this.icon,
  });

  void _showNumberPicker(BuildContext context) {
    // Sử dụng giá trị hiện tại hoặc giá trị mặc định
    int currentValue = value?.toInt() ?? ((minValue + maxValue) ~/ 2);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select $label${suffix != null ? " ($suffix)" : ""}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: NumberPicker(
                      value: currentValue,
                      minValue: minValue,
                      maxValue: maxValue,
                      step: step,
                      itemHeight: 50,
                      axis: Axis.horizontal,
                      onChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton(
                      label: 'Confirm',
                      onPressed: () {
                        onValueSelected(currentValue.toDouble());
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        GestureDetector(
          onTap: () => _showNumberPicker(context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isError ? Colors.red : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value == null
                      ? label
                      : '${value!.toInt()}${suffix != null ? " $suffix" : ""}',
                  style: TextStyle(
                    color: value == null ? Colors.grey.shade600 : Colors.black,
                  ),
                ),
                Icon(icon, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
