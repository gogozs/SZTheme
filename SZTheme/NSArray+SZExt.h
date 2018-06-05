//
//  NSArray+SZExt.h
//  PersonalCustom
//
//  Created by songzhou on 2018/4/18.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (SZExt)

- (void)sz_each:(void(^)(ObjectType obj))block;
- (void)sz_each_with_index:(void(^)(ObjectType obj, NSInteger index))block;

- (NSArray *)sz_map:(id(^)(ObjectType obj))block;
- (NSArray<ObjectType> *)sz_filter:(BOOL(^)(ObjectType obj))block;

- (ObjectType)sz_find:(BOOL(^)(ObjectType obj))block;
@end
