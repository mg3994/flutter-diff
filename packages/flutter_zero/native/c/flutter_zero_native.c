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
    struct NativeViewNode* next;
} NativeViewNode;

static intptr_t g_next_handle = 10000;
static FlutterZeroEventCallback g_event_callback = NULL;
static NativeViewNode* g_node_head = NULL;

static NativeViewNode* find_node(intptr_t handle) {
    NativeViewNode* curr = g_node_head;
    while (curr) {
        if (curr->handle == handle) return curr;
        curr = curr->next;
    }
    return NULL;
}

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
    node->next = g_node_head;
    g_node_head = node;

    return handle;
}

FLUTTER_ZERO_EXPORT void FlutterZero_UpdateView(intptr_t handle, const char* propsJson) {
    NativeViewNode* node = find_node(handle);
    if (node && propsJson) {
        if (node->propsJson) free(node->propsJson);
        node->propsJson = strdup(propsJson);
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_RemoveView(intptr_t handle) {
    NativeViewNode** curr = &g_node_head;
    while (*curr) {
        if ((*curr)->handle == handle) {
            NativeViewNode* to_delete = *curr;
            *curr = to_delete->next;
            if (to_delete->type) free(to_delete->type);
            if (to_delete->propsJson) free(to_delete->propsJson);
            if (to_delete->children) free(to_delete->children);
            free(to_delete);
            return;
        }
        curr = &((*curr)->next);
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_AppendChild(intptr_t parentHandle, intptr_t childHandle) {
    NativeViewNode* parent = find_node(parentHandle);
    NativeViewNode* child = find_node(childHandle);
    if (parent && child) {
        child->parent = parent;
        parent->children = (NativeViewNode**)realloc(parent->children, sizeof(NativeViewNode*) * (parent->childCount + 1));
        parent->children[parent->childCount++] = child;
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_RemoveChild(intptr_t parentHandle, intptr_t childHandle) {
    NativeViewNode* parent = find_node(parentHandle);
    if (parent) {
        size_t idx = 0;
        int found = 0;
        for (size_t i = 0; i < parent->childCount; i++) {
            if (parent->children[i]->handle == childHandle) {
                found = 1;
                idx = i;
                break;
            }
        }
        if (found) {
            parent->children[idx]->parent = NULL;
            for (size_t i = idx; i < parent->childCount - 1; i++) {
                parent->children[i] = parent->children[i + 1];
            }
            parent->childCount--;
        }
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_UpdateLayout(intptr_t handle, double x, double y, double width, double height) {
    NativeViewNode* node = find_node(handle);
    if (node) {
        node->x = x;
        node->y = y;
        node->width = width;
        node->height = height;
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_RegisterEventCallback(FlutterZeroEventCallback callback) {
    g_event_callback = callback;
}

FLUTTER_ZERO_EXPORT void FlutterZero_DispatchNativeEvent(intptr_t handle, const char* eventName, const char* dataJson) {
    if (g_event_callback) {
        g_event_callback(handle, eventName, dataJson);
    }
}
