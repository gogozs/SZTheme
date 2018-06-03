//
//  SZThemeManager.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZThemeManager.h"
#import <SZColorHex/SZColorHex.h>
#import "SZThemeLexer.h"
#import "SZThemeApplyProtocol.h"

@interface SZThemeManager ()

@property (nonatomic, readwrite) NSHashTable<__kindof UIView<SZThemeStyleApply> *> *views;

@property (nonatomic) SZThemeLexer *lexer;

@end

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
        _views = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        _lexer = [SZThemeLexer new];
    }
    return self;
}

#pragma mark - private
- (void)_addView:(__kindof UIView *)view {
    if (!_currentTheme) {
        return;
    }
    
    NSString *kclass = NSStringFromClass([view class]);
    if (_currentTheme.styles[kclass]) {
        [_views addObject:view];
    } else if (view.sztheme_id) {
        if (_currentTheme.styles[[_lexer selectorNameForKey:view.sztheme_id]]) {
            [_views addObject:view];
        }
    }
}

- (NSString *)_selectorForView:(__kindof UIView *)view {
    if (view.sztheme_id) {
        return [_lexer selectorNameForKey:view.sztheme_id];
    }
    
    return NSStringFromClass([view class]);
}

- (void)_applyStyleToView:(UIView<SZThemeStyleApply> *)view {
    
    SZThemeStyle *style = _currentTheme.styles[[self _selectorForView:view]];
    
    if (!style) {
        return;
    }
    
    [view applyStyle:style];
    
}

#pragma mark - API
- (void)setup {
    _lightTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"json"]];
    _darkTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style_dark" ofType:@"json"]];
    
    _currentTheme = _lightTheme;
}

- (void)changeTheme:(SZTheme *)theme {
    _currentTheme = theme;
    
    for (UIView<SZThemeStyleApply> *view in self.views) {
        [self _applyStyleToView:view];
    }
}

 - (void)applyStyleToView:(UIView *)view {
     if (![view conformsToProtocol:@protocol(SZThemeStyleApply)]) {
         return;
     }
     
     [self _addView:view];
   
     [self _applyStyleToView:(UIView<SZThemeStyleApply> *)view];
 }

@end
