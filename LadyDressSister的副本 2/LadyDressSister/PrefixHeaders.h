//
//  PrefixHeaders.h
//  Qingwen
//
//  Created by Aimy on 7/1/15.
//  Copyright (c) 2015 iQing. All rights reserved.
//

#ifndef Qingwen_PrefixHeaders_h
#define Qingwen_PrefixHeaders_h

#ifdef DEBUG

#define NSLog(...) NSLog(__VA_ARGS__)

#else

//干掉log
#define NSLog(...) {}
//干掉断言

#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define _NSAssertBody

#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QWDefine.h"
#import "QWNetWorkService.h"
#import <BlocksKit/BlocksKit.h>
#import "WebModel.h"
#endif
