//
//  SZTheme.h
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZThemeStyle;
@interface SZTheme : NSObject

@property (nonatomic, readonly) NSDictionary<NSString *, SZThemeStyle *> *styles;

- (instancetype)initWithFilePath:(NSString *)file;

@end
