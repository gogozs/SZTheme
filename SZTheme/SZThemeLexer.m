//
//  SZThemeLexer.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZThemeLexer.h"

@implementation SZThemeLexer

- (NSString * _Nullable)selectorNameForKey:(NSString *)key {
    if ([self isClassSelectorWithSelector:key] ||
        [self isIdSelectorWithSelector:key]) {
        return [key substringFromIndex:1];
    }
    
    return nil;
}

- (BOOL)isClassSelectorWithSelector:(NSString *)selector {
    if ([selector characterAtIndex:0] == SELECTOR_TOKEN_CLASS) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isIdSelectorWithSelector:(NSString *)selector {
    if ([selector characterAtIndex:0] == SELECTOR_TOKEN_ID) {
        return YES;
    }
    
    return NO;
}


@end
