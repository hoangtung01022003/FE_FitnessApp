import 'package:flutter/material.dart';
import 'package:finess_app/services/cors_image_service.dart';

class GifTestPage extends StatelessWidget {
  const GifTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // URL GIF cần kiểm tra
    const String testGifUrl = 'https://v1.cdn.exercisedb.dev/media/27NNGFr.gif';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test GIF Display'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hiển thị GIF với CorsImageWidget',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Hiển thị GIF với CorsImageWidget đã tối ưu
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const CorsImageWidget(
                  imageUrl: testGifUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Hiển thị GIF thông thường với Image.network',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Hiển thị GIF thông thường để so sánh
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Image.network(
                  testGifUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.orange,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lỗi: $error',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Chi tiết URL:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(testGifUrl),
              const SizedBox(height: 16),

              // Nút để xóa cache
              ElevatedButton.icon(
                onPressed: () {
                  GifCacheManager.clearCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa cache ảnh')),
                  );
                },
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Xóa cache ảnh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
