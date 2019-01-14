//
//  QWDefine.h
//  Qingwen
//
//  Created by Aimy on 7/1/15.
//  Copyright (c) 2015 iQing. All rights reserved.
//

#ifndef Qingwen_QWDefine_h
#define Qingwen_QWDefine_h

//end edting
#define END_EDITING [[[UIApplication sharedApplication].delegate window] endEditing:YES]

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf            = self
#define STRONG_SELF STRONG_SELF_NIL_RETURN
#define KVO_STRONG_SELF KVO_STRONG_SELF_NIL_RETURN

#define STRONG_SELF_NIL_RETURN __strong typeof(weakSelf)self = weakSelf; if ( ! self) return ;
#define KVO_STRONG_SELF_NIL_RETURN __strong typeof(weakSelf)kvoSelf = weakSelf; if ( ! kvoSelf) return ;
//判断设备
#define IS_IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define HRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:1.0]

#define HRGBA(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:a]

//设备当前宽高
#define ISIPHONEX    (UISCREEN_WIDTH == 375.f && UISCREEN_HEIGHT == 812.f)
#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define FONT(A) [UIFont systemFontOfSize:A]

#define kMaxX(X) CGRectGetMaxX(X)
#define kMaxY(Y) CGRectGetMaxY(Y)

// 单例
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}





#endif

