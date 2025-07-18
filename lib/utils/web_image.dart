import 'package:flutter/material.dart';

// Stub không thực thi
class WebImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const WebImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trả về một widget rỗng trên mobile
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Text('GIF only available on web platform'),
      ),
    );
  }

  static bool get isSupported => false;
}
