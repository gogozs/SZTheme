//
//  SZThemeStyle.m
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZThemeStyle.h"
#import "SZThemeAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SZThemeStyle

- (instancetype)init {
    return [self initWithAttributes:@[]];
}

- (instancetype)initWithAttributes:(NSArray<SZThemeAttribute *> *)attributes {
    self = [super init];
    if (self) {
        _attributes = attributes;
    }
    
    return self;
}

- (instancetype)initWithSelector:(NSString *)selector values:(NSDictionary<NSString *, NSDictionary *> *)values {
    self = [super init];
    if (self) {
        _selector = selector;
        
        NSMutableArray *ret = [@[] mutableCopy];
        [values enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
            SZThemeAttribute *attribute = [SZThemeAttribute attributeWithKey:key value:obj];;
            [ret addObject:attribute];
        }];
        _attributes = ret;
    }
    
    return self;
}

+ (instancetype)styleWithAttributes:(NSArray<SZThemeAttribute *> *)attributes {
    return [[SZThemeStyle alloc] initWithAttributes:attributes];
}

+ (instancetype)styleWithSelector:(NSString *)selector values:(NSDictionary<NSString *, NSDictionary *> *)values {
    return [[SZThemeStyle alloc] initWithSelector:selector values:values];
}
@end
NS_ASSUME_NONNULL_END
