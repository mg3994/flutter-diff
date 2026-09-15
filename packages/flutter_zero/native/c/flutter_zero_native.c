#include "flutter_zero_native.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct NativeViewNode {
    intptr_t handle;
    char* type;
    char* propsJson;
    double x, y, width, height;
    struct NativeViewNode* parent;
    struct NativeViewNode** children;
    size_t childCount;
} NativeViewNode;

static intptr_t g_next_handle = 10000;
static FlutterZeroEventCallback g_event_callback = NULL;

FLUTTER_ZERO_EXPORT intptr_t FlutterZero_CreateView(const char* type, const char* propsJson) {
    intptr_t handle = ++g_next_handle;
    NativeViewNode* node = (NativeViewNode*)malloc(sizeof(NativeViewNode));
    if (!node) return 0;

    node->handle = handle;
    node->type = strdup(type ? type : "");
    node->propsJson = strdup(propsJson ? propsJson : "{}");
    node->x = 0; node->y = 0; node->width = 0; node->height = 0;
    node->parent = NULL;
    node->children = NULL;
    node->childCount = 0;

    return handle;
}

FLUTTER_ZERO_EXPORT void FlutterZero_UpdateView(intptr_t handle, const char* propsJson) {
    (void)handle;
    (void)propsJson;
}

FLUTTER_ZERO_EXPORT void FlutterZero_RemoveView(intptr_t handle) {
    (void)handle;
}

FLUTTER_ZERO_EXPORT void FlutterZero_AppendChild(intptr_t parentHandle, intptr_t childHandle) {
    (void)parentHandle;
    (void)childHandle;
}

FLUTTER_ZERO_EXPORT void FlutterZero_RemoveChild(intptr_t parentHandle, intptr_t childHandle) {
    (void)parentHandle;
    (void)childHandle;
}

FLUTTER_ZERO_EXPORT void FlutterZero_UpdateLayout(intptr_t handle, double x, double y, double width, double height) {
    (void)handle;
    (void)x; (void)y; (void)width; (void)height;
}

FLUTTER_ZERO_EXPORT void FlutterZero_RegisterEventCallback(FlutterZeroEventCallback callback) {
    g_event_callback = callback;
}

FLUTTER_ZERO_EXPORT void FlutterZero_DispatchNativeEvent(intptr_t handle, const char* eventName, const char* dataJson) {
    if (g_event_callback) {
        g_event_callback(handle, eventName, dataJson);
    }
}
