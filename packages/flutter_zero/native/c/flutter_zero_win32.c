#include "flutter_zero_native.h"

#if defined(_WIN32)
#include <windows.h>

typedef struct Win32ViewNode {
    intptr_t handle;
    HWND hwnd;
    char* type;
    struct Win32ViewNode* parent;
} Win32ViewNode;

static HINSTANCE g_hInstance = NULL;

FLUTTER_ZERO_EXPORT HWND FlutterZero_Win32_CreateControl(HWND parentHwnd, const char* type, const char* title, int x, int y, int width, int height) {
    DWORD style = WS_CHILD | WS_VISIBLE;
    const char* className = "STATIC";

    if (strcmp(type, "Button") == 0) {
        className = "BUTTON";
        style |= BS_PUSHBUTTON;
    } else if (strcmp(type, "TextField") == 0) {
        className = "EDIT";
        style |= WS_BORDER | ES_LEFT;
    }

    HWND hwnd = CreateWindowA(
        className,
        title ? title : "",
        style,
        x, y, width, height,
        parentHwnd,
        NULL,
        g_hInstance,
        NULL
    );

    return hwnd;
}

FLUTTER_ZERO_EXPORT void FlutterZero_Win32_SetLayout(HWND hwnd, int x, int y, int width, int height) {
    if (hwnd) {
        SetWindowPos(hwnd, NULL, x, y, width, height, SWP_NOZORDER | SWP_NOACTIVATE);
    }
}
#endif
