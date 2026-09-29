class NetworkImageCache {
  final Map<String, String> _cachedUrls = {};

  static final NetworkImageCache instance = NetworkImageCache._();

  NetworkImageCache._();

  void cacheImage(String url, String localPath) {
    _cachedUrls[url] = localPath;
  }

  String? getCachedPath(String url) => _cachedUrls[url];

  bool isCached(String url) => _cachedUrls.containsKey(url);

  void clear() {
    _cachedUrls.clear();
  }
}
