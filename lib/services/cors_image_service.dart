import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
// Thêm imports cho hỗ trợ Web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:ui' as ui;

/// Widget hiển thị ảnh GIF với hiệu suất tối ưu
/// Hỗ trợ hiển thị GIF động trên web và ảnh tĩnh trên mobile
class CorsImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? exerciseId;
  final bool enableAnimationOnWeb; // Tùy chọn cho phép animation trên web

  const CorsImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.exerciseId,
    this.enableAnimationOnWeb = true, // Mặc định cho phép GIF động trên web
  }) : super(key: key);

  @override
  State<CorsImageWidget> createState() => _CorsImageWidgetState();
}

class _CorsImageWidgetState extends State<CorsImageWidget> {
  bool _isLoading = true;
  String? _webImageId;

  // Tạo cache key dựa trên URL và ID
  String get _cacheKey =>
      widget.exerciseId != null && widget.exerciseId!.isNotEmpty
          ? '${widget.imageUrl}_${widget.exerciseId}'
          : widget.imageUrl;

  @override
  void initState() {
    super.initState();
    // Xử lý khác nhau giữa web và mobile
    if (kIsWeb && widget.enableAnimationOnWeb) {
      _setupWebImage();
    } else {
      _loadImage();
    }
  }

  @override
  void dispose() {
    // Dọn dẹp tài nguyên web nếu cần
    if (kIsWeb && _webImageId != null) {
      // Gỡ bỏ element khỏi DOM khi widget bị hủy
      html.Element? element = html.document.getElementById(_webImageId!);
      if (element != null) {
        element.remove();
      }
    }
    super.dispose();
  }

  // Thiết lập hiển thị ảnh GIF trên web
  void _setupWebImage() {
    if (kIsWeb) {
      // Tạo ID duy nhất cho HTML element
      _webImageId =
          'gif-image-${widget.imageUrl.hashCode}-${DateTime.now().millisecondsSinceEpoch}';

      // Tạo thẻ img HTML
      final imgElement = html.ImageElement()
        ..src = widget.imageUrl
        ..id = _webImageId!
        ..style.objectFit = _convertBoxFit(widget.fit)
        ..style.width = '100%'
        ..style.height = '100%';

      // Xử lý sự kiện loading
      imgElement.onLoad.listen((event) {
        if (mounted) setState(() => _isLoading = false);
      });

      imgElement.onError.listen((event) {
        if (mounted) setState(() => _isLoading = false);
      });

      // Đăng ký view factory cho Flutter Web
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry
          .registerViewFactory(_webImageId!, (int viewId) => imgElement);

      if (mounted) setState(() {});
    }
  }

  // Chuyển đổi BoxFit của Flutter sang object-fit của CSS
  String _convertBoxFit(BoxFit? fit) {
    switch (fit) {
      case BoxFit.cover:
        return 'cover';
      case BoxFit.contain:
        return 'contain';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitWidth:
        return 'contain';
      case BoxFit.fitHeight:
        return 'contain';
      case BoxFit.scaleDown:
        return 'scale-down';
      default:
        return 'cover'; // Mặc định là cover
    }
  }

  // Chỉ tải ảnh một lần và không tạo hoạt ảnh (cho mobile)
  Future<void> _loadImage() async {
    // Đánh dấu bắt đầu tải
    setState(() {
      _isLoading = true;
    });

    try {
      // Chỉ cần đảm bảo ảnh được lưu vào cache, nhưng không xử lý nó
      await GifCacheManager.instance.getSingleFile(
        widget.imageUrl,
        key: _cacheKey,
      );
    } catch (e) {
      // Xử lý lỗi nhưng không hiển thị cho người dùng
    } finally {
      // Hoàn tất tải
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        // Làm đẹp khung chứa ảnh
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Tránh hiệu ứng lấp lánh ở góc
      child: _buildImageContent(),
    );
  }

  // Quyết định hiển thị content dựa vào nền tảng
  Widget _buildImageContent() {
    // Sử dụng cách tiếp cận khác cho web và mobile
    if (kIsWeb && widget.enableAnimationOnWeb && _webImageId != null) {
      return Stack(
        children: [
          // HtmlElementView cho phép hiển thị nội dung HTML trong Flutter Web
          HtmlElementView(viewType: _webImageId!),

          // Hiển thị placeholder nếu đang tải
          if (_isLoading) _buildPlaceholder(),
        ],
      );
    } else {
      return _buildImageView();
    }
  }

  // Xây dựng widget hiển thị ảnh đơn giản (cho mobile)
  Widget _buildImageView() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      cacheKey: _cacheKey,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover, // Sử dụng cover để ảnh lấp đầy khung

      // Giảm thời gian fade để tránh hiệu ứng nháy
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),

      // Kiểm soát bộ nhớ cache
      maxWidthDiskCache: 800,
      maxHeightDiskCache: 800,

      // Tùy chọn widget thay thế
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),

      // Chặn GIF animation trên mobile
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          fit: widget.fit ?? BoxFit.cover,
          gaplessPlayback: true, // Ngăn nháy khi thay đổi ảnh
          filterQuality: FilterQuality.high,
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: widget.placeholder ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 36,
                  color: Colors.orange.shade300,
                ),
                const SizedBox(height: 8),
                Text(
                  'Đang tải bài tập',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade100,
      child: widget.errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 36,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Không thể tải hình ảnh',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

// Cache manager đơn giản hóa
class GifCacheManager {
  static const key = 'exerciseImageCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 14), // Cache lâu hơn - 2 tuần
      maxNrOfCacheObjects: 200, // Tăng số lượng ảnh có thể lưu
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  static Future<void> clearCache() async {
    await instance.emptyCache();
  }
}
