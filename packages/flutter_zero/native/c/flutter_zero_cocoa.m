#include "flutter_zero_native.h"

#if defined(__APPLE__)
#import <Cocoa/Cocoa.h>

FLUTTER_ZERO_EXPORT void* FlutterZero_Cocoa_CreateView(const char* type, const char* title, double x, double y, double width, double height) {
    NSRect frame = NSMakeRect(x, y, width, height);

    if (strcmp(type, "Button") == 0) {
        NSButton* button = [[NSButton alloc] initWithFrame:frame];
        [button setTitle:[NSString stringWithUTF8String:title ? title : ""]];
        [button setButtonType:NSButtonTypeMomentaryPushIn];
        [button setBezelStyle:NSBezelStyleRounded];
        return (__bridge_retained void*)button;
    } else if (strcmp(type, "Text") == 0) {
        NSTextField* textField = [NSTextField labelWithString:[NSString stringWithUTF8String:title ? title : ""]];
        [textField setFrame:frame];
        return (__bridge_retained void*)textField;
    }

    NSView* view = [[NSView alloc] initWithFrame:frame];
    return (__bridge_retained void*)view;
}

FLUTTER_ZERO_EXPORT void FlutterZero_Cocoa_AddSubView(void* parentPtr, void* childPtr) {
    if (parentPtr && childPtr) {
        NSView* parent = (__bridge NSView*)parentPtr;
        NSView* child = (__bridge NSView*)childPtr;
        [parent addSubview:child];
    }
}

FLUTTER_ZERO_EXPORT void FlutterZero_Cocoa_SetFrame(void* viewPtr, double x, double y, double width, double height) {
    if (viewPtr) {
        NSView* view = (__bridge NSView*)viewPtr;
        [view setFrame:NSMakeRect(x, y, width, height)];
    }
}
#endif
