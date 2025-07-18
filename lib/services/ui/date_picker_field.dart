import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final bool isError;
  final String? errorMessage;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.isError = false,
    this.errorMessage,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime defaultInitialDate = initialDate ??
        selectedDate ??
        now.subtract(const Duration(days: 365 * 25));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: defaultInitialDate,
      firstDate: firstDate ?? DateTime(1920),
      lastDate: lastDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
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
          onTap: () => _selectDate(context),
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
                  selectedDate == null
                      ? label
                      : DateFormat('dd/MM/yyyy').format(selectedDate!),
                  style: TextStyle(
                    color: selectedDate == null
                        ? Colors.grey.shade600
                        : Colors.black,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
