//
//  UIColor+SZColorHex.m
//  SZColorHex
//
//  Created by Song Zhou on 24/11/2017.
//  Copyright © 2017 Song Zhou. All rights reserved.
//

#import "UIColor+SZColorHex.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIColor (SZColorHex)

+ (UIColor *)colorFromHex:(uint32_t)color {
    uint8_t rmd = 0xFF;
    uint8_t mask = 0xFF;
    
    uint8_t step = 8;
    uint8_t length = 3;
    CGFloat r, g, b;
    r = g = b = 0;
    for (int i = 0; i < length; i++) {
        NSUInteger offSet = step * i;
        CGFloat percent = (color >> offSet & mask) / (double)rmd;
        switch (i) {
            case 0: {
                b = percent;
                break;
            }
            case 1: {
                g = percent;
                break;
            }
            case 2: {
                r = percent;
            }
        }
    }
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned int colorHex = 0;
    
    [[NSScanner scannerWithString:hexString] scanHexInt:&colorHex];
    
    return [UIColor colorFromHex:colorHex];
}

@end
NS_ASSUME_NONNULL_END
