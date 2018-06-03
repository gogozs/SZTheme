//
//  UIView+SZThemeStyleApply.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UIView+SZThemeStyleApply.h"
#import "SZThemeAttribute.h"
#import "SZThemeStyle.h"
#import <SZColorHex/SZColorHex.h>

@implementation UIView (SZThemeStyleApply)

- (void)applyStyle:(SZThemeStyle *)style {
    [style.attributes enumerateObjectsUsingBlock:^(SZThemeAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = obj.value;
        if ([obj.name isEqualToString:@"backgroundColor"]) {
            value = [UIColor colorFromHexString:obj.value];
        }
        
        [self setValue:value forKey:obj.name];
    }];
}

@end
