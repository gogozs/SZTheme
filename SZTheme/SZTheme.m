//
//  SZTheme.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZTheme.h"
#import <SZColorHex/SZColorHex.h>
#import "SZThemeStyle.h"
#import "SZThemeLexer.h"

@interface SZTheme ()

@property (nonatomic, readwrite, copy) NSString *fileName;
@property (nonatomic, readwrite) NSDictionary<NSString *, SZThemeStyle *> *styles;
@property (nonatomic) NSDictionary *theme;

@property (nonatomic) SZThemeLexer *lexer;

@end

@implementation SZTheme

- (instancetype)initWithFilePath:(NSString *)file {
    self = [super init];
    if (self) {
        _fileName = [file lastPathComponent];
        NSData *themeData = [NSData dataWithContentsOfFile:file];
        _theme = [NSJSONSerialization JSONObjectWithData:themeData options:NSJSONReadingAllowFragments error:nil];
        
        _lexer = [SZThemeLexer new];
        [self _generateStyles];
    }
    
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }

    SZTheme *otherTheme = other;
    
    return [self.fileName isEqualToString:otherTheme.fileName];
}

- (NSUInteger)hash
{
    return self.fileName.hash;
}

#pragma mark - private
- (void)_generateStyles {
    NSMutableDictionary *ret = [@{} mutableCopy];
    [_theme enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *selector = [self.lexer selectorNameForKey:key];

        if (!selector) {
            return;
        }
        
        SZThemeStyle *style = [SZThemeStyle styleWithSelector:selector values:obj];
        ret[selector] = style;
    }];
    
    _styles = ret;
    
}

@end
