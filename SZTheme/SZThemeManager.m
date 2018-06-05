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
#import "SZFileSourceObserver.h"
#import "SZFoundation.h"

@interface SZThemeManager ()

@property (nonatomic, readwrite) NSHashTable<__kindof UIView<SZThemeStyleApply> *> *views;

@property (nonatomic) SZThemeLexer *lexer;
@property (nonatomic, readonly) SZFileSourceObserver *fileSourceObserver;
@property (nonatomic, copy) NSArray<SZTheme *> *themes;
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

- (void)_applyStyleToView:(UIView<SZThemeStyleApply> *)view theme:(SZTheme *)theme {
    
    SZThemeStyle *style = theme.styles[[self _selectorForView:view]];
    
    if (!style) {
        return;
    }
    
    [view applyStyle:style];
}

- (void)_applyTheme:(SZTheme *)theme {
    for (UIView<SZThemeStyleApply> *view in self.views) {
        [self _applyStyleToView:view theme:theme];
    }
}

- (void)_reloadThemeFromFilePath:(NSString *)filePath {
    NSLog(@"reload theme:%@", filePath);
    SZTheme *newTheme = [[SZTheme alloc] initWithFilePath:filePath];

    // update theme
    NSMutableArray<SZTheme *> *themes = [self.themes mutableCopy];
    [themes replaceObjectAtIndex:[self.themes indexOfObject:newTheme] withObject:newTheme];

    _currentTheme = newTheme;
    [self _applyTheme:_currentTheme];
}

- (NSString *)_urlForFileNamed:(NSString *)fileName {
    char const *filePath = __FILE__;
    NSURL *fileURL = [NSURL fileURLWithFileSystemRepresentation:filePath isDirectory:NO relativeToURL:nil];
    NSURL *directoryURL = [fileURL URLByDeletingLastPathComponent];
    NSURL *styleURL = [directoryURL URLByAppendingPathComponent:fileName];
    NSError *error;
    BOOL isReachable = [styleURL checkResourceIsReachableAndReturnError:&error];
    NSAssert(isReachable, @"File at url:%@ is not reachable:%@", styleURL, error);
    
    return styleURL.path;
}

- (SZTheme *)_themeForPath:(NSString *)path {
    NSParameterAssert(path);
    
    NSString *themeFileName = [path lastPathComponent];
    
    SZTheme *theme = [_themes sz_find:^BOOL(SZTheme *theme) {
        return [theme.fileName isEqualToString:themeFileName];
    }];
    
    return theme;
}

- (void)_setupFileSourceObserver {
    NSArray<NSString *> *filePaths = [_themes sz_map:^id(SZTheme *theme) {
        return [self _urlForFileNamed:theme.fileName];
    }];
    
    _fileSourceObserver = [[SZFileSourceObserver alloc] initWithFilePaths:filePaths];

    @weakify(self)
    _fileSourceObserver.updateBlock = ^(NSString * _Nonnull filePath, NSError * _Nullable error) {
        @strongify(self)
        SZTheme *theme = [self _themeForPath:filePath];
        if (![theme isEqual:self.currentTheme]) {
            return;
        }
        
        [self _reloadThemeFromFilePath:filePath];
    };
}

#pragma mark - API
- (void)setup {
    NSMutableArray<SZTheme *> *themes = [@[] mutableCopy];
    _lightTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"json"]];
    _darkTheme = [[SZTheme alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"style_dark" ofType:@"json"]];
    
    _currentTheme = _lightTheme;
    
    [themes addObject:_lightTheme];
    [themes addObject:_darkTheme];
    
    _themes = [themes copy];
    
    [self _setupFileSourceObserver];
}

- (void)changeTheme:(SZTheme *)theme {
    _currentTheme = theme;
    
    [self _applyTheme:_currentTheme];
}

 - (void)applyStyleToView:(UIView *)view {
     if (![view conformsToProtocol:@protocol(SZThemeStyleApply)]) {
         return;
     }
     
     [self _addView:view];
   
     [self _applyStyleToView:(UIView<SZThemeStyleApply> *)view theme:_currentTheme];
 }

@end
