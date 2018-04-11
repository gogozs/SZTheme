//
//  SZThemeManager.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZThemeManager.h"
#import <SZColorHex/SZColorHex.h>

@implementation SZThemeManager

+ (instancetype)sharedManager {
    static SZThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SZThemeManager new];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lightTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"json"]];
        _darkTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style_dark" ofType:@"json"]];
    }
    return self;
}

- (void)changeToTheme:(SZTheme *)theme fromView:(UIView *)view {
    _currentTheme = theme;
    [self applyStyleForView:view theme:theme];
}

#pragma mark -
/**
 dfs for view, apply style for view
 
 @param view the view to start dfs
 @param theme the theme to apply
 */
- (void)applyStyleForView:(__kindof UIView *)view theme:(SZTheme *)theme {
    for (UIView *v in view.subviews) {

        NSString *classString = NSStringFromClass(v.class);
        if (theme.classSelectors[classString]) {
            if ([v isKindOfClass:[UIButton class]]) {
                [self _applyStyleForButton:(UIButton *)v styles:theme.classSelectors[classString]];
            }
            
            if ([v isKindOfClass:[UISegmentedControl class]]) {
                [self _applyStyleForSegmentedControl:(UISegmentedControl *)v styles:theme.classSelectors[classString]];
            }
            
        }
        NSString *themeID = v.sztheme_id ? [v.sztheme_id substringFromIndex:1] : nil;
        if (themeID) {
           // default
            [self _applyStyleForView:v styles:theme.idSelectors[themeID]];
        }
        
        [self applyStyleForView:v theme:theme];
    }
    
}

- (void)_applyStyleForButton:(UIButton *)button styles:(NSDictionary *)styles {
    [styles enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"titleColor"]) {
            [button setTitleColor:[UIColor colorFromHexString:obj] forState:UIControlStateNormal];
        }
    }];
}

- (void)_applyStyleForSegmentedControl:(UISegmentedControl*)segmentedControl styles:(NSDictionary *)styles {
    [styles enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"tintColor"]) {
            segmentedControl.tintColor = [UIColor colorFromHexString:obj];
        }
    }];
}

- (void)_applyStyleForView:(UIView *)view styles:(NSDictionary *)styles {
    [styles enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"backgroundColor"]) {
            view.backgroundColor = [UIColor colorFromHexString:obj];
        }
    }];
}

@end
