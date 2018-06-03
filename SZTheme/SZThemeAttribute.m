//
//  SZThemeAttribute.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZThemeAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SZThemeAttribute

- (instancetype)init {
    return [self initWithState:nil name:@"" value:@""];
}

- (instancetype)initWithState:(NSString * _Nullable)state name:(NSString *)name value:(NSString *)value {
    self = [super init];
    if (self) {
        _state = state;
        _name = name;
        _value = value;
    }
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    self = [super init];
    if (self) {
        /// attribute
        if ([value isKindOfClass:[NSString class]]) {
            _name = key;
            _value = value;
            /// state: attribute
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, NSString *> *dict= (NSDictionary *)value;
            
            _state = key;
            _name = dict.allKeys.firstObject;
            _value = dict[_name];
        }
    }
    
    return self;
}

+ (instancetype)attributeWithState:(NSString *)state name:(NSString *)name value:(NSString *)value {
    return [[SZThemeAttribute alloc] initWithState:state name:name value:value];
}

+ (instancetype)attributeName:(NSString *)name value:(NSString *)value {
    return [[SZThemeAttribute alloc] initWithState:nil name:name value:value];
}

+ (instancetype)attributeWithKey:(NSString *)key value:(id)value {
    return [[SZThemeAttribute alloc] initWithKey:key value:value];
}
@end
NS_ASSUME_NONNULL_END
