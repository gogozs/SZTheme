//
//  UIView+SZTheme.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UIView+SZTheme.h"
#import <objc/runtime.h>
#import "SZThemeManager.h"
#import "SZThemeStyle.h"
#import "SZThemeAttribute.h"
#import <SZColorHex/SZColorHex.h>

static const void *SZ_THEME_ID_KEY = &SZ_THEME_ID_KEY;

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (SZTheme)

+ (void)load {
    swizzleMethod([self class], @selector(willMoveToSuperview:), @selector(sz_willMoveToSuperview:));
}

- (void)sz_willMoveToSuperview:(UIView *)newSupeview {
    [self sz_willMoveToSuperview:newSupeview];

    if (newSupeview) {
        if (self.sztheme_id) {
            NSLog(@"%@-%@", self.sztheme_id, self);
        }
    }
    
    [[SZThemeManager sharedManager] applyStyleToView:self];
}

- (NSString *)sztheme_id {
    return objc_getAssociatedObject(self, SZ_THEME_ID_KEY);
}

- (void)setSztheme_id:(NSString *)sztheme_id {
    objc_setAssociatedObject(self, SZ_THEME_ID_KEY, sztheme_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

