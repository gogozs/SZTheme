//
//  UISegmentedControl+SZThemeStyleApply.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UISegmentedControl+SZThemeStyleApply.h"
#import "SZThemeAttribute.h"
#import "SZThemeStyle.h"
#import <SZColorHex/SZColorHex.h>

@implementation UISegmentedControl (SZThemeStyleApply)

- (void)applyStyle:(SZThemeStyle *)style {
    [style.attributes enumerateObjectsUsingBlock:^(SZThemeAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value;
        if ([obj.name isEqualToString:@"tintColor"]) {
             value = [UIColor colorFromHexString:obj.value];
        }
        
        [self setValue:value forKey:obj.name];
    }];
}
@end
