# Flutter Zero (`flutter_zero`)

A modular application and runtime UI framework built in Dart.

Unlike traditional Flutter (which relies on `dart:ui`, Skia, or Impeller to draw pixels onto a canvas), **Flutter Zero** decouples the Dart reactive widget and state management tree from canvas rendering.

Instead, Flutter Zero delegates rendering directly to native platform UI toolkits (such as iOS UIKit, Android Views, WinUI, or AppKit/GTK) via **Dart FFI native interop** or backend drivers.

## Architecture

- **Widget & Element Lifecycle**: Flutter-like reactive component model (`Widget`, `StatelessWidget`, `StatefulWidget`, `State`, `Element`).
- **Native Render Objects (`NativeRenderNode`)**: Calculates layout geometry (BoxConstraints, Size, Offset) and keeps native properties.
- **Backend Drivers (`NativeUIBackend`)**:
  - `FFINativeUIBackend`: Invokes native C/C++ FFI exports to create/update platform native controls.
  - `VirtualNativeUIBackend`: In-memory view tree representation for testing, inspection, and cross-platform headless operations.
