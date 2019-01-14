//
//  QWNetWorkService.m
//  LadyDressSister
//
//  Created by qingwen on 2018/7/12.
//  Copyright © 2018年 LadyDressSister. All rights reserved.
//

#import "QWNetWorkService.h"
#define BASE_URL @"https://quin-gate.iqing.com"

@implementation QWNetWorkService

+ (instancetype)shareInstance
{
    static QWNetWorkService *QWNet = nil;
    static dispatch_once_t    onceToken;
    
    dispatch_once(&onceToken, ^{
        QWNet = [[QWNetWorkService alloc] init];
    });
    return QWNet;
}

#pragma mark - GET/POST请求
// 返回值:AFHTTPRequestOperation *
- (AFHTTPRequestOperation*)requestWithURL:(NSString*)URLString
                                   params:(id)params
                               httpMethod:(NSString*)httpMethod
                           hasCertificate:(BOOL)hasCer
                                   sucess:(SuccessHandle)successBlock
                                  failure:(FailureHandle)failureBlock
{
    // 1.拼接URL
    NSString *URL = [NSString stringWithFormat:@"%@", URLString];
    
    URL                                               = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];       // 去掉URL里的空格,防止空格导致的请求崩溃
    URL                                               = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 如果路径中包含中文,需要转换成可用的编码格式
    
    // 2.初始化请求管理对象,设置规则
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil]; // 或者是下面132行的方法
    
    if (hasCer)
    {                                                                                                                                                                   ///有cer证书时AF会自动从bundle中寻找并加载cer格式的证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
    }
    else
    {                  ///无cer证书的情况,忽略证书,实现Https请求
        manager.securityPolicy.allowInvalidCertificates = YES;
    }
    
    // 3.发送请求
    AFHTTPRequestOperation *operation;
    //防止循环引用
    __weak                  typeof(*&self) ws = self;
    
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];//不区分大小写
    if (compResult1 == NSOrderedSame)            // GET请求
    {
        operation = [manager GET:URL parameters:params success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successBlock)
            {
                successBlock(operation,[ws decodeData:responseObject]);
            }
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureBlock)
            {
                failureBlock(operation,error);
            }
        }];
    }
    NSComparisonResult compResult2 =[httpMethod caseInsensitiveCompare:@"POST"];//不区分大小写
    if (compResult2 == NSOrderedSame)      // POST请求
    {
        BOOL isFile = NO;
        
        for (NSString *key in [params allKeys])
        {
            id value = params[key];
            
            if ([value isKindOfClass:[NSData class]])
            {
                isFile = YES;
                break;
            }
        }
        
        if (!isFile)
        {
            // 参数中不包含NSData
            operation = [manager POST:URL parameters:params success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successBlock)
                {
                    successBlock(operation,[ws decodeData:responseObject]);
                }
            } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failureBlock)
                {
                    failureBlock(operation,error);
                }
            }];
        }
        else
        {
            // 参数中包含NSData
            operation = [manager POST:URL parameters:params constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
                for (NSString *key in [params allKeys])
                {
                    id value = params[key];
                    
                    // 判断参数是否是文件数据
                    if ([value isKindOfClass:[NSData class]])
                    {
                        // 将文件数据添加到formData中
                        // image/jpeg、text/plain、text/html、application/octet-stream , fileName后面一定要加后缀,否则上传文件会出错
                        [formData appendPartWithFileData:value name:key fileName:[NSString stringWithFormat:@"%@.jpg", key] mimeType:@"image/jpeg"];
                    }
                }
            } success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successBlock)
                {
                    successBlock(operation,[ws decodeData:responseObject]);
                }
                NSLog(@"response所有的头文件:%@", operation.response.allHeaderFields);
            } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failureBlock)
                {
                    failureBlock(operation,error);
                }
            }];
        }
    }
    
    /**
     *  @discussion   下面如果写成 operation.responseSerializer = [AFJSONResponseSerializer serializer]会出现1016的错误.这种只能解析返回的是Json类型的数据,其他的都无法解析。
     *
     *  @add
     *
     *  AFJSONResponseSerializer *jsonResponse = [AFJSONResponseSerializer serializer];
     *  jsonResponse.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
     *  operation.responseSerializer = jsonResponse;
     *
     *  这样就可以自动解析了
     *  此处我是手动解析的,因为有的数据还是无法自动解析
     */
    
    // 4.返回数据的格式(默认是json格式)
    /**
     *  当AF带的方法不能自动解析的时候再打开下面的
     *  此处我是让它返回的是NSData二进制数据类型,然后自己手动解析;
     *  默认情况下,提交的是二进制数据请求,返回Json格式的数据
     */
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    return operation;
} /* requestWithURL */

///解析Json数据
- (id)decodeData:(id)data
{
    return [data isKindOfClass:[NSData class]] ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] : data;
}


- (void)setOpration:(AFHTTPRequestOperation *)opration
{
    opration.securityPolicy.allowInvalidCertificates = YES;
    
}

- (void)managerSetOpration:(AFHTTPRequestOperationManager *)opration
{
    opration.securityPolicy.allowInvalidCertificates = YES;
}
@end
