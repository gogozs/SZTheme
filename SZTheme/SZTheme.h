//
//  SZTheme.h
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTheme : NSObject

- (instancetype)initWithFilePath:(NSString *)file;

@property (nonatomic) NSMutableDictionary *classSelectors;
@property (nonatomic) NSMutableDictionary *idSelectors;

@end
