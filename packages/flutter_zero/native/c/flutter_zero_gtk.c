#include "flutter_zero_native.h"

#if defined(__linux__) && !defined(ANDROID)
#include <gtk/gtk.h>

FLUTTER_ZERO_EXPORT GtkWidget* FlutterZero_GTK_CreateWidget(const char* type, const char* label) {
    if (strcmp(type, "Button") == 0) {
        return gtk_button_new_with_label(label ? label : "");
    } else if (strcmp(type, "Text") == 0) {
        return gtk_label_new(label ? label : "");
    } else if (strcmp(type, "TextField") == 0) {
        return gtk_entry_new();
    }
    return gtk_fixed_new();
}

FLUTTER_ZERO_EXPORT void FlutterZero_GTK_AddChild(GtkWidget* parent, GtkWidget* child, int x, int y) {
    if (GTK_IS_FIXED(parent) && child) {
        gtk_fixed_put(GTK_FIXED(parent), child, x, y);
    } else if (GTK_IS_CONTAINER(parent) && child) {
        gtk_container_add(GTK_CONTAINER(parent), child);
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_GTK_SetSize(GtkWidget* widget, int width, int height) {
    if (widget) {
        gtk_widget_set_size_request(widget, width, height);
    }
}
#endif
