//
//  NSArray+SZExt.m
//  PersonalCustom
//
//  Created by songzhou on 2018/4/18.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "NSArray+SZExt.h"

@implementation NSArray (SZExt)

- (void)sz_each:(void(^)(id obj))block {
    if (!block) {
        return;
    }
    
    for (id obj in self) {
        block(obj);
    }
}

- (void)sz_each_with_index:(void(^)(id obj, NSInteger index))block {
    if (!block) {
        return;
    }
    
    for (int i = 0; i < self.count; i++) {
        id o = self[i];
        block(o, i);
    }
}

- (NSArray *)sz_map:(id(^)(id obj))block {
    if (!block) {
        return self;
    }
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id obj in self) {
        [ret addObject:block(obj) ?: [NSNull null]];
    }
    
    return ret;
}

- (NSArray *)sz_filter:(BOOL(^)(id obj))block {
    if (!block) {
        return self;
    }
    
    NSMutableArray *ret = [@[] mutableCopy];
    for (id obj in self) {
        if (block(obj)) {
            [ret addObject:obj];
        }
    }
    
    return ret;
}

- (id)sz_find:(BOOL(^)(id obj))block {
    if (!block) {
        return nil;
    }
    
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }
    
    return nil;
}

@end
