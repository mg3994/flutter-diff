#ifndef FLUTTER_ZERO_UIKIT_H
#define FLUTTER_ZERO_UIKIT_H

#import <UIKit/UIKit.h>

@interface FlutterZeroUIKit : NSObject

+ (instancetype)sharedInstance;
- (intptr_t)createViewWithType:(NSString *)widgetType props:(NSDictionary *)props;
- (void)appendChild:(intptr_t)childHandle toParent:(intptr_t)parentHandle;
- (void)updateLayoutForHandle:(intptr_t)handle frame:(CGRect)frame;
- (UIView *)viewForHandle:(intptr_t)handle;

@end

#endif // FLUTTER_ZERO_UIKIT_H
