//
//  UIViewController+Printer.m
//  TestProject
//
//  Created by dqf on 2017/7/5.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIViewController+Printer.h"
#import <objc/runtime.h>

@implementation UIViewController (Printer)

#if DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self replaceClass:[self class] originalSelector:@selector(viewDidAppear:) withCustomSelector:@selector(custom_viewDidAppear:)];
    });
}

+ (void)replaceClass:(Class)class originalSelector:(SEL)originalSelector withCustomSelector:(SEL)customSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, customSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            customSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}

- (void)custom_viewDidAppear:(BOOL)animated {
    [self custom_viewDidAppear:animated];
    NSLog(@"viewDidAppear: %@", NSStringFromClass([self class]));
}
#endif

@end
