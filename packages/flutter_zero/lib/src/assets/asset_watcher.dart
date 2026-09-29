import 'dart:async';

class AssetWatcher {
  final List<String> watchedPaths = [];
  final StreamController<String> _changeController = StreamController<String>.broadcast();

  Stream<String> get onAssetChanged => _changeController.stream;

  void watchAsset(String assetPath) {
    if (!watchedPaths.contains(assetPath)) {
      watchedPaths.add(assetPath);
    }
  }

  void notifyChanged(String assetPath) {
    if (watchedPaths.contains(assetPath)) {
      _changeController.add(assetPath);
    }
  }

  void dispose() {
    _changeController.close();
  }
}
