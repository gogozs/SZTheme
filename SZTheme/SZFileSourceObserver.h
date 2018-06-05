//
//  SZFileSourceObserver.h
//  SZTheme
//
//  Created by songzhou on 2018/6/5.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZFileObservationContext : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource fileDescriptor:(int)fileDescriptor path:(NSString *)path NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) dispatch_source_t dispatchSource;
@property (nonatomic, readonly) int fileDescriptor;
@property (nonatomic, readonly, copy) NSString *path;

@end


typedef void(^SZThemeDidUpdate)(NSString *, NSError * _Nullable);

@interface SZFileSourceObserver : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFilePaths:(NSArray<NSString *> *)filePaths NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy) SZThemeDidUpdate updateBlock;
@property (nonatomic, readonly) NSURL *filePath;
@end

NS_ASSUME_NONNULL_END
