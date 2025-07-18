import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ImageHelper {
  // Backend URL cho proxy
  static const String _baseProxyUrl =
      'http://192.168.1.18:8000/api/image-proxy';

  // Trả về URL thông qua proxy nếu đang chạy trên web, ngược lại trả về URL gốc
  static String getProxyUrl(String originalUrl) {
    if (kIsWeb) {
      // Mã hóa URL gốc
      final encodedUrl = Uri.encodeComponent(originalUrl);
      return '$_baseProxyUrl?url=$encodedUrl';
    }

    // Nếu không phải web, sử dụng URL gốc
    return originalUrl;
  }

  // Widget hiển thị hình ảnh với xử lý cho web
  static Widget networkImageWithProxy({
    required String imageUrl,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    double? placeholderSize,
    BorderRadius? borderRadius,
  }) {
    final url = getProxyUrl(imageUrl);

    // Widget cơ bản
    Widget imageWidget = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      memCacheHeight: 800, // Tối ưu bộ nhớ cache
      memCacheWidth: 800,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orange,
          size: placeholderSize ??
              (width != null && width < 100 ? width * 0.5 : 40),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: placeholderSize != null ? placeholderSize * 0.7 : 24,
            ),
            if (width == null ||
                width > 80) // Chỉ hiển thị text nếu có đủ không gian
              const SizedBox(height: 4),
            if (width == null || width > 80)
              const Text(
                'Không thể tải hình',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );

    // Nếu cần bo tròn góc
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  // Tính toán kích thước responsive dựa vào kích thước màn hình
  static double responsiveSize(BuildContext context, double percentage,
      {bool isWidth = true}) {
    if (isWidth) {
      return MediaQuery.of(context).size.width * percentage;
    } else {
      return MediaQuery.of(context).size.height * percentage;
    }
  }
}
