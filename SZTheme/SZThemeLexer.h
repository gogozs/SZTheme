//
//  SZThemeLexer.h
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

static char SELECTOR_TOKEN_CLASS = '.';
static char SELECTOR_TOKEN_ID = '#';

NS_ASSUME_NONNULL_BEGIN
@interface SZThemeLexer : NSObject

- (NSString * _Nullable)selectorNameForKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END
