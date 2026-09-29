# Flutter Zero Framework Architecture Guide

`flutter_zero` is a complete, modular, canvas-less application framework implemented in pure Dart.

## Core Philosophy

Standard Flutter applications rely on `dart:ui` and Skia/Impeller to rasterize pixels onto a single hardware-accelerated canvas. **Flutter Zero** bypasses canvas-based rendering entirely while retaining Flutter's core developer experience:

- **Reactive Component Model**: `Widget`, `Element`, `StatefulWidget`, `State`, `InheritedWidget`, and `GlobalKey`.
- **Constraint-Based Layout Engine**: Pure-Dart `BoxConstraints` calculation for tight, loose, and flex dimensions.
- **Native Platform UI Interop**: Directly drives OS native controls (UIKit, Android Views, WinUI, AppKit) via Dart FFI and JNI backend drivers.

---

## Architectural Layers

```
┌─────────────────────────────────────────────────────────┐
│                     Application Layer                   │
│   (Widgets, State, Navigation, Themes, Animations)      │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│                    Reactive Framework                   │
│      (Widget & Element Tree Diffing / Reconciliation)    │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│                      Layout Engine                      │
│     (BoxConstraints, Offset, Size, NativeRenderNodes)   │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│             NativeUIBackend Interface Driver            │
│  ├── FFINativeUIBackend (C Dynamic Library RPC)         │
│  ├── JNINativeUIBackend (Android JNI Invocation)        │
│  └── VirtualNativeUIBackend (In-Memory Headless Tree)   │
└─────────────────────────────────────────────────────────┘
```

---

## Native Backend Interop

### 1. FFI Driver (`FFINativeUIBackend`)
Invokes C-FFI function exports to communicate directly with C/C++ native UI wrappers on iOS, macOS, Windows, and Linux:

```c
intptr_t FlutterZero_CreateView(const char* type, const char* propsJson);
void FlutterZero_UpdateView(intptr_t handle, const char* propsJson);
void FlutterZero_UpdateLayout(intptr_t handle, double x, double y, double width, double height);
void FlutterZero_RemoveView(intptr_t handle);
```

### 2. Android JNI Driver (`JNINativeUIBackend`)
Maps view tree commands to Android JVM/JNI calls, instantiating native `android.view.View` subclasses.

### 3. Virtual Driver (`VirtualNativeUIBackend`)
An in-memory view tree simulator enabling unit testing, layout verification, and diagnostic inspection via `NativeTreeInspector`.

---

## Key Framework Features

- **Form Validation System**: `Form`, `FormFieldState`, `TextFormField`.
- **State Management & DI**: `ValueNotifier`, `ChangeNotifier`, `HydratedStateNotifier`, `Provider`, `Consumer`.
- **Animations**: `AnimationController`, `Tween`, `CurvedAnimation`, `KeyframeSequence`, `AnimatedContainer`.
- **Navigation & Overlays**: `Navigator`, `PageRoute`, `AlertDialog`, `TabBar`, `BottomNavigationBar`.
- **Advanced Layouts**: `Flex` (`Row`, `Column`, `Expanded`, `Flexible`), `Stack`, `Positioned`, `Wrap`, `ListView.builder`, `GridView`, `CustomScrollView`, `SliverList`.
- **Desktop & Platform Interop**: `MethodChannel`, `WindowController`, `NativeAssetBundle`, `Semantics`.
