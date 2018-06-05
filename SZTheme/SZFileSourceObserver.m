
//
//  SZFileSourceObserver.m
//  SZTheme
//
//  Created by songzhou on 2018/6/5.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZFileSourceObserver.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SZFileObservationContext

- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource fileDescriptor:(int)fileDescriptor path:(NSString *)path {
    NSParameterAssert(dispatchSource);
    NSParameterAssert(fileDescriptor != -1);
    NSParameterAssert(path);
    
    self = [super init];
    
    _dispatchSource = dispatchSource;
    _fileDescriptor = fileDescriptor;
    _path = path;
    
    return self;
}

@end

@interface SZFileSourceObserver ()

@property (nonatomic, readonly) dispatch_queue_t fileObservationQueue;
@property (nonatomic, readwrite, copy) NSURL *filePath;

@property (nonatomic) NSArray<SZFileObservationContext *> *observationContexts;

@end

@implementation SZFileSourceObserver

- (instancetype)initWithFilePaths:(NSArray<NSString *> *)filePaths {
    NSParameterAssert(filePaths);
    
    self = [super init];
    
    _fileObservationQueue = dispatch_queue_create(
                                                  "me.songzhou.sztheme.SZFileSourceObserver",
                                                  DISPATCH_QUEUE_CONCURRENT);
    
    
    _observationContexts = [self observeUpdatesToPaths:filePaths onQueue:_fileObservationQueue didUpdate:^(NSString * _Nonnull filePath) {
        if (self.updateBlock) {
            self.updateBlock(filePath, nil);
        }
    }];
    
    
    return self;
}

- (void)dealloc {
    for (SZFileObservationContext *context in self.observationContexts) {
        close(context.fileDescriptor);
    }
}

#pragma mark -
- (NSArray<SZFileObservationContext *> *)observeUpdatesToPaths:(NSArray<NSString *> *)paths onQueue:(dispatch_queue_t)queue didUpdate:(void(^)(NSString *))didUpdate {
    NSMutableArray<SZFileObservationContext *> *fileObservationContexts = [@[] mutableCopy];
    
    for (NSString *path in paths) {
        [fileObservationContexts addObject:[self observeUpdatesToPath:path onQueue:queue didUpdate:didUpdate]];
    }
    
    return [fileObservationContexts copy];
}

- (SZFileObservationContext *)observeUpdatesToPath:(NSString *)path onQueue:(dispatch_queue_t)queue didUpdate:(void(^)(NSString *))didUpdate {
    NSParameterAssert(path);
    NSParameterAssert(queue);
    NSParameterAssert(didUpdate);
    
    int fileDescriptor = open(path.fileSystemRepresentation, O_EVTONLY, 0);
    
    NSAssert(fileDescriptor != -1,
             @"Unable to subscribe to changes to the file %@, errno %@",
             path, @(errno)
             );
    
    dispatch_source_t source = dispatch_source_create(
                                                      DISPATCH_SOURCE_TYPE_VNODE,
                                                      fileDescriptor,
                                                      DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND,
                                                      queue);
    
    NSAssert(source, @"Unable to create a dispatch source for the file: %@", path);
    
    __weak typeof(self) __weak_self = self;
    __weak typeof(source) __weak_soruce = source;
    dispatch_source_set_event_handler(source, ^{
        typeof(__weak_soruce) source = __weak_soruce;
        
        unsigned long data = dispatch_source_get_data(source);
        if (data != 0) {
            dispatch_source_cancel(source);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(__weak_self) self = __weak_self;
                
                /// recreate dispatch source and file handle for events to continue to fire
                SZFileObservationContext *context = [self observeUpdatesToPath:path onQueue:queue didUpdate:didUpdate];
                [self updateObservationContext:context];

                didUpdate(path);
            });
        }
    });
    
    dispatch_source_set_cancel_handler(source, ^{
        close(fileDescriptor);
    });
    
    dispatch_resume(source);
    
    return [[SZFileObservationContext alloc] initWithDispatchSource:source fileDescriptor:fileDescriptor path:path];
}

- (void)updateObservationContext:(SZFileObservationContext *)contextToUpdate {
    NSParameterAssert(contextToUpdate != nil);
    
    NSMutableArray<SZFileObservationContext *> *observationContexts = [self.observationContexts mutableCopy];
    NSInteger indexToReplace = [observationContexts indexOfObjectPassingTest:^BOOL(SZFileObservationContext * _Nonnull context, NSUInteger idx, BOOL * _Nonnull stop) {
        return [context.path isEqualToString:contextToUpdate.path];
    }];
    
    NSAssert(indexToReplace != NSNotFound, @"Unable to locate context to replace");
    
    [observationContexts replaceObjectAtIndex:indexToReplace withObject:contextToUpdate];
    
    self.observationContexts = [observationContexts copy];
}

@end

NS_ASSUME_NONNULL_END
