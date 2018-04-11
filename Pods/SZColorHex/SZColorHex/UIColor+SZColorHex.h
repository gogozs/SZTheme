//
//  UIColor+SZColorHex.h
//  SZColorHex
//
//  Created by Song Zhou on 24/11/2017.
//  Copyright © 2017 Song Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIColor (SZColorHex)



/**
 return color from hex value
 
 @param hex color hex value (e.g., 0xE41B17)
 @return color from specfic hex
 */
+ (UIColor *)colorFromHex:(uint32_t)hex;


/**
 return color from hex string

 @param hexString color hex string (e.g., "0xE41B17")
 @return color from specfic hex string
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
NS_ASSUME_NONNULL_END
