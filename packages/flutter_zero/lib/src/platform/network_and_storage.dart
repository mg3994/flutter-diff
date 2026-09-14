import 'dart:async';
import 'package:dio/dio.dart';

export 'package:dio/dio.dart';

class ZeroHttpClient {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Dio get client => _dio;

  static Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );
  }

  static Future<Response<dynamic>> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class ZeroPreferences {
  static final Map<String, dynamic> _store = {};

  static Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  static String? getString(String key) {
    return _store[key] as String?;
  }

  static Future<void> setBool(String key, bool value) async {
    _store[key] = value;
  }

  static bool? getBool(String key) {
    return _store[key] as bool?;
  }

  static Future<void> clear() async {
    _store.clear();
  }
}
