#ifndef FLUTTER_ZERO_NATIVE_H
#define FLUTTER_ZERO_NATIVE_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
  #define FLUTTER_ZERO_EXPORT __declspec(dllexport)
#else
  #define FLUTTER_ZERO_EXPORT __attribute__((visibility("default")))
#endif

typedef void (*FlutterZeroEventCallback)(intptr_t handle, const char* eventName, const char* dataJson);

FLUTTER_ZERO_EXPORT intptr_t FlutterZero_CreateView(const char* type, const char* propsJson);
FLUTTER_ZERO_EXPORT void FlutterZero_UpdateView(intptr_t handle, const char* propsJson);
FLUTTER_ZERO_EXPORT void FlutterZero_RemoveView(intptr_t handle);
FLUTTER_ZERO_EXPORT void FlutterZero_AppendChild(intptr_t parentHandle, intptr_t childHandle);
FLUTTER_ZERO_EXPORT void FlutterZero_RemoveChild(intptr_t parentHandle, intptr_t childHandle);
FLUTTER_ZERO_EXPORT void FlutterZero_UpdateLayout(intptr_t handle, double x, double y, double width, double height);
FLUTTER_ZERO_EXPORT void FlutterZero_RegisterEventCallback(FlutterZeroEventCallback callback);
FLUTTER_ZERO_EXPORT void FlutterZero_DispatchNativeEvent(intptr_t handle, const char* eventName, const char* dataJson);

#ifdef __cplusplus
}
#endif

#endif // FLUTTER_ZERO_NATIVE_H
