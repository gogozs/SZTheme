//
//  SZThemeAttribute.h
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SZThemeAttribute : NSObject

@property (nonatomic, copy, nullable) NSString *state;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

+ (instancetype)attributeWithState:(NSString *)state name:(NSString *)name value:(NSString *)value;
+ (instancetype)attributeName:(NSString *)name value:(NSString *)value;
+ (instancetype)attributeWithKey:(NSString *)key value:(id)value;

- (instancetype)initWithState:(NSString * _Nullable)state name:(NSString *)name value:(NSString *)value NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithKey:(NSString *)key value:(id)value NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
