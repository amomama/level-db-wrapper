#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LevelDBForSwift.h"
#import "Wrapper.hpp"

FOUNDATION_EXPORT double level_db_wrapperVersionNumber;
FOUNDATION_EXPORT const unsigned char level_db_wrapperVersionString[];

