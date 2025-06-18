import 'package:flutter/material.dart';

class DatePickerService {
  /// Hiển thị date picker với xử lý ngày tương lai
  ///
  /// [context]: BuildContext hiện tại
  /// [initialDate]: Ngày được chọn ban đầu
  /// [firstDate]: Ngày đầu tiên có thể chọn
  /// [lastDate]: Ngày cuối cùng có thể chọn
  /// [primaryColor]: Màu chủ đạo cho date picker
  /// [preventFutureDates]: Nếu true, sẽ reset về ngày hiện tại khi chọn ngày tương lai
  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    Color primaryColor = Colors.orange,
    bool preventFutureDates = true,
  }) async {
    final now = DateTime.now();
    final initial = initialDate ?? DateTime(now.year - 18, now.month, now.day);
    final first = firstDate ?? DateTime(1900);
    final last = lastDate ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    // Xử lý ngày tương lai
    if (picked != null && preventFutureDates && picked.isAfter(now)) {
      return now;
    }

    return picked;
  }
}
