import 'dart:async';

class ZeroHttpResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;

  const ZeroHttpResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ZeroHttpClient {
  static Future<ZeroHttpResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return const ZeroHttpResponse(
      statusCode: 200,
      body: '{"status": "ok"}',
    );
  }

  static Future<ZeroHttpResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return const ZeroHttpResponse(
      statusCode: 201,
      body: '{"created": true}',
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
