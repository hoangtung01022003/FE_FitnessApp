import 'dart:io';
import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handleError(dynamic error) {
    String errorDescription = '';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          errorDescription =
              'Kết nối đến server quá hạn. Vui lòng kiểm tra kết nối internet và thử lại sau.';
          break;
        case DioExceptionType.sendTimeout:
          errorDescription =
              'Gửi yêu cầu đến server quá hạn. Vui lòng thử lại sau.';
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription =
              'Nhận phản hồi từ server quá hạn. Có thể server đang xử lý chậm, vui lòng thử lại sau.';
          break;
        case DioExceptionType.badResponse:
          errorDescription =
              'Nhận phản hồi lỗi từ server. Status code: ${error.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          errorDescription = 'Yêu cầu đã bị hủy';
          break;
        case DioExceptionType.connectionError:
          errorDescription =
              'Lỗi kết nối với server. Vui lòng kiểm tra kết nối internet.';
          break;
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            errorDescription =
                'Không thể kết nối đến server. Vui lòng kiểm tra địa chỉ server và kết nối internet.';
          } else {
            errorDescription = 'Đã xảy ra lỗi không xác định. ${error.message}';
          }
          break;
        default:
          errorDescription = 'Đã xảy ra lỗi không xác định: ${error.message}';
          break;
      }
    } else {
      errorDescription = 'Lỗi không xác định: $error';
    }

    return errorDescription;
  }
}
