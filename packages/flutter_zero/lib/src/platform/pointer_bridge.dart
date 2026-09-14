import 'dart:ffi' as ffi;

class NativePointerBridge {
  static ffi.Pointer<ffi.Void> handleToPointer(int handle) {
    return ffi.Pointer<ffi.Void>.fromAddress(handle);
  }

  static int pointerToHandle(ffi.Pointer<ffi.Void> pointer) {
    return pointer.address;
  }
}
