//
//  SZTheme.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZTheme.h"
#import <SZColorHex/SZColorHex.h>

static char SELECTOR_TOKEN_CLASS = '.';
static char SELECTOR_TOKEN_ID = '#';

@interface SZTheme ()

@property (nonatomic) NSDictionary *theme;


@end

@implementation SZTheme

- (instancetype)initWithFilePath:(NSString *)file {
    self = [super init];
    if (self) {
        NSData *themeData = [NSData dataWithContentsOfFile:file];
        _theme = [NSJSONSerialization JSONObjectWithData:themeData options:NSJSONReadingAllowFragments error:nil];
        
        _classSelectors = @{}.mutableCopy;
        _idSelectors = @{}.mutableCopy;
        
        [self _parseSelectorsWithTheme:_theme];
    }
    
    return self;
}

#pragma mark - private
- (void)_parseSelectorsWithTheme:(NSDictionary *)theme {
    [theme enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSDictionary *  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self _isClassSelectorWithSelector:key]) {
            [self _addToClassSelectors:key value:obj];
        } else if ([self _isIdSelectorWithSelector:key]) {
            [self _addToIdSelectors:key value:obj];
        }
    }];
}


- (BOOL)_isClassSelectorWithSelector:(NSString *)selector {
    if ([selector characterAtIndex:0] == SELECTOR_TOKEN_CLASS) {
        return YES;
    }
    
    return NO;
}

- (BOOL)_isIdSelectorWithSelector:(NSString *)selector {
    if ([selector characterAtIndex:0] == SELECTOR_TOKEN_ID) {
        return YES;
    }
    
    return NO;
}

- (void)_addToClassSelectors:(NSString *)rawKey value:(NSDictionary *)value {
    NSString *key = [rawKey substringFromIndex:1];
    
    _classSelectors[key] = value;
}

- (void)_addToIdSelectors:(NSString *)rawKey value:(NSDictionary *)value {
    NSString *key = [rawKey substringFromIndex:1];
    _idSelectors[key] = value;
}


@end
