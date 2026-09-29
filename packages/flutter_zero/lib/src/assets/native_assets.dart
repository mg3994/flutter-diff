import 'dart:ffi' as ffi;

class NativeAssetBundle {
  final Map<String, ffi.DynamicLibrary> _loadedLibraries = {};

  static final NativeAssetBundle instance = NativeAssetBundle._();

  NativeAssetBundle._();

  ffi.DynamicLibrary? loadNativeLibrary(String assetId) {
    if (_loadedLibraries.containsKey(assetId)) {
      return _loadedLibraries[assetId];
    }

    try {
      final library = ffi.DynamicLibrary.open(assetId);
      _loadedLibraries[assetId] = library;
      return library;
    } catch (_) {
      try {
        final processLib = ffi.DynamicLibrary.process();
        _loadedLibraries[assetId] = processLib;
        return processLib;
      } catch (_) {
        return null;
      }
    }
  }

  bool isLibraryLoaded(String assetId) => _loadedLibraries.containsKey(assetId);
}
