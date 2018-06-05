//
//  SZMacro.h
//  SZTheme
//
//  Created by songzhou on 2018/6/5.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#ifndef SZMacro_h
#define SZMacro_h

// ===========
// keywordify
// ===========
// Details about the choice of backing keyword:
//
// The use of @try/@catch/@finally can cause the compiler to suppress
// return-type warnings.
// The use of @autoreleasepool {} is not optimized away by the compiler,
// resulting in superfluous creation of autorelease pools.
//
// Since neither option is perfect, and with no other alternatives, the
// compromise is to use @autorelease in DEBUG builds to maintain compiler
// analysis, and to use @try/@catch otherwise to avoid insertion of unnecessary
// autorelease pools.
#if defined(DEBUG) && !defined(NDEBUG)
#define ext_keywordify autoreleasepool {}
#else
#define ext_keywordify try {} @catch (...) {}
#endif

#define weakify(VAR) \
ext_keywordify \
__weak typeof(VAR) VAR ## _weak_ = VAR;

#define strongify(VAR) \
ext_keywordify \
__strong typeof(VAR) VAR = VAR ## _weak_;

#endif /* SZMacro_h */
