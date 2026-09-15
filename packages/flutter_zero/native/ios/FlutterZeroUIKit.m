#import "FlutterZeroUIKit.h"

@interface FlutterZeroUIKit ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIView *> *views;
@property (nonatomic, assign) intptr_t handleCounter;
@end

@implementation FlutterZeroUIKit

+ (instancetype)sharedInstance {
    static FlutterZeroUIKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FlutterZeroUIKit alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _views = [NSMutableDictionary dictionary];
        _handleCounter = 40000;
    }
    return self;
}

- (intptr_t)createViewWithType:(NSString *)widgetType props:(NSDictionary *)props {
    intptr_t handle = ++self.handleCounter;
    UIView *view = nil;

    if ([widgetType isEqualToString:@"Button"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"Native Button" forState:UIControlStateNormal];
        view = btn;
    } else if ([widgetType isEqualToString:@"Text"]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Native Text";
        view = label;
    } else if ([widgetType isEqualToString:@"TextField"]) {
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        view = textField;
    } else {
        view = [[UIView alloc] init];
    }

    self.views[@(handle)] = view;
    return handle;
}

- (void)appendChild:(intptr_t)childHandle toParent:(intptr_t)parentHandle {
    UIView *parent = self.views[@(parentHandle)];
    UIView *child = self.views[@(childHandle)];
    if (parent && child) {
        [parent addSubview:child];
    }
}

- (void)updateLayoutForHandle:(intptr_t)handle frame:(CGRect)frame {
    UIView *view = self.views[@(handle)];
    if (view) {
        view.frame = frame;
    }
}

- (UIView *)viewForHandle:(intptr_t)handle {
    return self.views[@(handle)];
}

@end
