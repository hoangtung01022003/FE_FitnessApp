import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://172.20.192.1:8000/api/';

  // Sử dụng CORS proxy để bypass CORS
  final String _corsProxyUrl = 'https://corsproxy.io/?';

  ApiService() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  // Phương thức helper để xử lý URL với proxy CORS
  String _getUrl(String endpoint) {
    if (kIsWeb) {
      return _corsProxyUrl + Uri.encodeComponent('$_baseUrl/$endpoint');
    }
    return '$_baseUrl/$endpoint';
  }

  // Các phương thức API với CORS proxy
  Future<Response> register(Map<String, dynamic> data) async {
    try {
      return await _dio.post(_getUrl('register'), data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login(Map<String, dynamic> data) async {
    try {
      return await _dio.post(_getUrl('login'), data: data);
    } catch (e) {
      rethrow;
    }
  }

  // Phương thức để kiểm tra profile của người dùng
  Future<Response> getProfile(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get(_getUrl('profile'));
    } catch (e) {
      rethrow;
    }
  }
}
