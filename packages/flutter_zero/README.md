# Flutter Zero (`flutter_zero`)

A modular, lightweight Dart application framework featuring a **canvas-less native platform UI rendering layer**.

## Architectural Overview

Standard Flutter renders user interfaces by drawing custom vector pixels onto a single hardware-accelerated canvas (`dart:ui` -> Skia/Impeller engine).

**Flutter Zero** removes the canvas rendering pipeline and `dart:ui`. It preserves Flutter's reactive widget tree, reactive element diffing/reconciliation, state management, and constraint-based layout engine—while delegating native UI control instantiation and layout geometry directly to OS native toolkits (Android Views, iOS UIKit, WinUI, AppKit) via **Dart FFI & JNI interop**.

```
[ Your Dart Code ]
        ↓
[ Flutter Zero Reactive Widgets & Elements ]
        ↓
[ BoxConstraints & Layout Geometry Engine ]
        ↓
[ NativeUIBackend Abstraction (FFI / JNI / Virtual) ]
        ↓
┌──────────────┬──────────────┬──────────────┐
│ Android Views│  iOS UIKit   │ WinUI / GTK  │
└──────────────┴──────────────┴──────────────┘
```

## Features

- **Zero Canvas Dependency**: Completely free of `dart:ui`, Skia, and Impeller.
- **Dart FFI & JNI Native Interop**: Native platform C/C++ FFI (`FFINativeUIBackend`) and Android JNI (`JNINativeUIBackend`) drivers.
- **Headless Virtual Backend**: In-memory view tree engine (`VirtualNativeUIBackend`) for unit testing, inspection, and CI pipelines.
- **Reactive Widget System**: `Widget`, `StatelessWidget`, `StatefulWidget`, `InheritedWidget`, `GlobalKey`, `State`.
- **Comprehensive UI Catalog**:
  - Layout: `Container`, `Padding`, `Center`, `SizedBox`, `Row`, `Column`, `Stack`, `Positioned`, `Flexible`, `Expanded`, `Wrap`, `Chip`, `ListView.builder`.
  - Controls & Inputs: `Text`, `Button`, `TextField`, `Form`, `TextFormField`, `AdaptiveButton`, `AdaptiveTextField`.
  - Media & Graphics: `Image` (`Image.network`, `Image.asset`), `CustomPaint` (`NativeCanvas`).
  - Navigation & Overlays: `Navigator`, `PageRoute`, `AlertDialog`, `showDialog`.
- **State Management & Animations**: `ChangeNotifier`, `ValueNotifier`, `ValueListenableBuilder`, `Provider`, `Consumer`, `AnimationController`, `Tween`, `RestorationBucket`.
- **DevTools Inspection**: `NativeTreeInspector` for JSON view hierarchy diagnostics.

## Quick Start

```dart
import 'package:flutter_zero/flutter_zero.dart';

void main() {
  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FFFFFF',
      child: Column(
        children: [
          const Text('Hello Flutter Zero!'),
          AdaptiveButton(
            onPressed: () => print('Native Button Pressed!'),
            child: const Text('Click Me'),
          ),
        ],
      ),
    ),
    backend: backend,
  );

  app.run();
  print(backend.printTree());
}
```
