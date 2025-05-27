#import "UIApplication+Hook.h"
#import <objc/runtime.h>

@implementation UIApplication (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(openURL:);
        SEL swizzledSelector = @selector(g_openURL:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
            NSLog(@"openURL: 方法交换成功！");
        } else {
            NSLog(@"openURL: 方法交换失败！");
        }
    });
}

- (BOOL)g_openURL:(NSURL *)url {
    NSLog(@"拦截到 openURL: %@", url);
    // 注意：由于方法交换，调用 g_openURL: 实际上会调用原 openURL: 实现
    // 这里我们调用新版 API
    if ([UIApplication.sharedApplication respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"openURL:options:completionHandler: 返回 %d", success);
        }];
    } else {
        // 如果低于 iOS 10，调用原始实现
        return [self g_openURL:url]; // 注意：由于方法交换，这里 g_openURL: 实际上是原 openURL:
    }
    return YES;
}

@end
