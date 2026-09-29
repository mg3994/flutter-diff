# DartNative Toolchain & Flutter Zero Integration Guide

This guide explains how **Flutter Zero** operates within the **DartNative** CLI toolchain environment (`dn`).

---

## Architecture Synergy

DartNative provides a rebranded, privacy-focused Dart SDK and CLI toolchain (`dn`) with zero telemetry and specialized FFI native asset bindings. **Flutter Zero** complements this architecture by providing a 100% canvas-less Dart application framework that bypasses `dart:ui`/Skia canvas rendering and delegates view hierarchy management directly to platform OS controls via Dart FFI and JNI.

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Zero App                     │
│    (Canvas-less Reactive Widgets & Layout Engine)     │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│               NativeUIBackend Driver                   │
│   ├── FFINativeUIBackend (Win32 / Cocoa / GTK / UIKit) │
│   └── JNINativeUIBackend (Android Views)              │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                 DartNative SDK Toolchain               │
│   ├── `dn` CLI Tool (`dn build apk / ios / desktop`)   │
│   ├── `DartNativeBridge` FFI Asset Resolver           │
│   └── https://cdn.dartnative.com Endpoint              │
└────────────────────────────────────────────────────────┘
```

---

## Building Flutter Zero Applications with DartNative CLI

### Android APK Build (`dn build apk`)
```bash
dn build apk --release
```
Bundles `libapp.so` alongside `libflutter_zero_native.so` into the output APK at `build/app/outputs/dn-apk/app-release.apk`.

### iOS IPA Package (`dn build ipa`)
```bash
dn build ipa --release
```
Compiles Dart AOT machine code into `App.framework` and embeds `FlutterZeroUIKit.m` native view structures.

### Desktop Targets (`dn build macos` / `windows` / `linux`)
```bash
dn build macos
dn build windows
dn build linux
```
Compiles C/Objective-C/C++ embedder code (`flutter_zero_win32.c`, `flutter_zero_cocoa.m`, `flutter_zero_gtk.c`) using CMake into standalone desktop executables.
