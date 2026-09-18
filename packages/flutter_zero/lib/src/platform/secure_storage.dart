import 'dart:async';

class ZeroSecureStorage {
  static final Map<String, String> _secureVault = {};

  static Future<void> write({required String key, required String value}) async {
    _secureVault[key] = value;
  }

  static Future<String?> read({required String key}) async {
    return _secureVault[key];
  }

  static Future<void> delete({required String key}) async {
    _secureVault.remove(key);
  }

  static Future<void> deleteAll() async {
    _secureVault.clear();
  }
}
