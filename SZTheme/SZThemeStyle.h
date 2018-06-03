//
//  SZThemeStyle.h
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZThemeAttribute;

NS_ASSUME_NONNULL_BEGIN
@interface SZThemeStyle : NSObject

@property (nonatomic, copy) NSString *selector;
@property (nonatomic) NSArray<SZThemeAttribute *> *attributes;

+ (instancetype)styleWithAttributes:(NSArray<SZThemeAttribute *> *)attributes;
+ (instancetype)styleWithSelector:(NSString *)selector values:(NSDictionary<NSString *, NSDictionary *> *)values;

- (instancetype)initWithAttributes:(NSArray<SZThemeAttribute *> *)attributes NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSelector:(NSString *)selector values:(NSDictionary<NSString *, NSDictionary *> *)values NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
