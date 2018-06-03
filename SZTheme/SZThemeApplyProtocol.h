//
//  SZThemeApplyProtocol.h
//  SZTheme
//
//  Created by songzhou on 2018/6/3.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#ifndef SZThemeApplyProtocol_h
#define SZThemeApplyProtocol_h

@class SZThemeStyle;
@protocol SZThemeStyleApply <NSObject>

@required
- (void)applyStyle:(SZThemeStyle *)style;

@end

#endif /* SZThemeApplyProtocol_h */
