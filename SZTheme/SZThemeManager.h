//
//  SZThemeManager.h
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTheme.h"
#import "UIView+SZTheme.h"

@protocol SZThemeStyleApply;
@interface SZThemeManager : NSObject

@property (nonatomic, readonly) NSHashTable<__kindof UIView<SZThemeStyleApply> *> *views;

+ (instancetype)sharedManager;
- (void)setup;

- (void)changeTheme:(SZTheme *)theme;
- (void)applyStyleToView:(UIView *)view;

@property (nonatomic) SZTheme *currentTheme;

@property (nonatomic) SZTheme *lightTheme;
@property (nonatomic) SZTheme *darkTheme;


@end
