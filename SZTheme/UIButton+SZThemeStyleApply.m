//
//  UIButton+SZThemeStyleApply.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UIButton+SZThemeStyleApply.h"
#import "SZThemeAttribute.h"
#import "SZThemeStyle.h"
#import <SZColorHex/SZColorHex.h>

static UIControlState _ui_control_state(NSString *state) {
    if ([state isEqualToString:@"normal"]) {
        return UIControlStateNormal;
    }
    
    if ([state isEqualToString:@"selected"]) {
        return UIControlStateSelected;
    }
    
    return UIControlStateNormal;
}

@implementation UIButton (SZThemeStyleApply)

- (void)applyStyle:(SZThemeStyle *)style {
    [style.attributes enumerateObjectsUsingBlock:^(SZThemeAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id value;
        if ([obj.name isEqualToString:@"backgroundColor"]) {
            value = [UIColor colorFromHexString:obj.value];
            [self setValue:value forKey:obj.name];
        } else if ([obj.name isEqualToString:@"titleColor"]) {
            value = [UIColor colorFromHexString:obj.value];
        }
        
        if (obj.state) {
            [self setTitleColor:value forState:_ui_control_state(obj.state)];
        }
    }];
}

@end
