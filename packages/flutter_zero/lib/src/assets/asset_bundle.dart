import 'dart:async';

abstract class AssetBundle {
  Future<String> loadString(String key);
}

class NetworkAssetBundle extends AssetBundle {
  final Map<String, String> _mockAssets = {};

  void registerMockAsset(String key, String content) {
    _mockAssets[key] = content;
  }

  @override
  Future<String> loadString(String key) async {
    if (_mockAssets.containsKey(key)) {
      return _mockAssets[key]!;
    }
    return 'Asset $key mock content';
  }
}

final AssetBundle rootBundle = NetworkAssetBundle();
