import 'dart:ffi' as ffi;

class DartNativeSDKInfo {
  final String sdkVersion;
  final String cliExecutable;
  final String cdnBaseUrl;
  final bool zeroTelemetry;

  const DartNativeSDKInfo({
    this.sdkVersion = '1.0.0-dn',
    this.cliExecutable = 'dn',
    this.cdnBaseUrl = 'https://cdn.dartnative.com',
    this.zeroTelemetry = true,
  });

  Map<String, dynamic> toJson() => {
        'sdkVersion': sdkVersion,
        'cliExecutable': cliExecutable,
        'cdnBaseUrl': cdnBaseUrl,
        'zeroTelemetry': zeroTelemetry,
      };
}

class DartNativeAssetRegistry {
  static final Map<String, String> _registeredAssets = {};

  static void registerAsset(String name, String path) {
    _registeredAssets[name] = path;
  }

  static String? getAssetPath(String name) => _registeredAssets[name];

  static bool isRegistered(String name) => _registeredAssets.containsKey(name);
}

class DartNativeBridge {
  final DartNativeSDKInfo sdkInfo;

  DartNativeBridge({this.sdkInfo = const DartNativeSDKInfo()});

  ffi.DynamicLibrary? loadNativeAssetLibrary(String libraryName) {
    try {
      return ffi.DynamicLibrary.open(libraryName);
    } catch (_) {
      try {
        return ffi.DynamicLibrary.process();
      } catch (_) {
        return null;
      }
    }
  }

  String resolveCdnAssetUrl(String relativePath) {
    return '${sdkInfo.cdnBaseUrl}/$relativePath';
  }
}
