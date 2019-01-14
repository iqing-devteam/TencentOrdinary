//
//  QWNetWorkService.h
//  LadyDressSister
//
//  Created by qingwen on 2018/7/12.
//  Copyright © 2018年 LadyDressSister. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//用于回调请求成功或者失败的信息，修改可以解析operation的数据,也可以解析responseObject数据
typedef void (^SuccessHandle)(AFHTTPRequestOperation *operation,id responseObject);
typedef void (^FailureHandle)(AFHTTPRequestOperation *operation,NSError *error);

@interface QWNetWorkService : NSObject

/**
 *  单例
 *
 *  @return 实例化后的self
 */
+ (instancetype)shareInstance;

/**
 *  @abstract GET && POST请求
 *
 *  @param urlString : 请求地址
 *  @param params : 请求参数
 *  @param httpMethod : GET/POST 请求
 *  @param hasCer : 是否有证书（对于Https请求）
 *  @param successBlock/failureBlock : 回调block
 *
 *  @discussion
 */
- (AFHTTPRequestOperation *)requestWithURL:(NSString *)URLString params:(id)params httpMethod:(NSString *)httpMethod hasCertificate:(BOOL)hasCer sucess:(SuccessHandle)successBlock failure:(FailureHandle)failureBlock;

@end
