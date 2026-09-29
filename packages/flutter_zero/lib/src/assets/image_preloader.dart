import 'dart:async';
import 'image_cache.dart';

class AsyncImagePreloader {
  static Future<bool> preload(String url) async {
    if (NetworkImageCache.instance.isCached(url)) {
      return true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
    NetworkImageCache.instance.cacheImage(url, '/tmp/cached_${url.hashCode}.png');
    return true;
  }
}
