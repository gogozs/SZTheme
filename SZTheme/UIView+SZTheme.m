//
//  UIView+SZTheme.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UIView+SZTheme.h"
#import <objc/runtime.h>

static const void *SZ_THEME_ID_KEY = &SZ_THEME_ID_KEY;

@implementation UIView (SZTheme)

- (NSString *)sztheme_id {
    return objc_getAssociatedObject(self, SZ_THEME_ID_KEY);
}

- (void)setSztheme_id:(NSString *)sztheme_id {
    objc_setAssociatedObject(self, SZ_THEME_ID_KEY, sztheme_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
