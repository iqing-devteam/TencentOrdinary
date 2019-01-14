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

#import "MTKDeallocator.h"
#import "MTKObserver.h"
#import "MTKObserving.h"
#import "MTKObservingMacros.h"
#import "NSObject+MTKObserving.h"

FOUNDATION_EXPORT double Block_KVOVersionNumber;
FOUNDATION_EXPORT const unsigned char Block_KVOVersionString[];

