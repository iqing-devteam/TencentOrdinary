//
//  ViewController.m
//  LadyDressSister
//
//  Created by qingwen on 2018/7/11.
//  Copyright © 2018年 LadyDressSister. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "QWDefine.h"
#import <AdSupport/AdSupport.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "WeakScriptMessageDelegate.h"
@interface ViewController ()<WKScriptMessageHandler,WKUIDelegate,UITextFieldDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic ,strong )WKWebViewConfiguration *config;
@property (nonatomic, strong) NSMutableDictionary *dataSorce;
@end
@implementation ViewController
- (void)setNewOrientation:(BOOL)fullscreen

{
    
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
    
    [self setNewOrientation:YES];//调用转屏代码
    
    [self setupViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    
    NSString *url = @"https://quin.iqing.com/ngame/app_config_v2?package_name=com.iqing.xunji.ios";
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = responseObject;
            self.dataSorce = dict[@"data"];
        
            [self setupViews];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self getData];
    }];
    

    
    
}

- (void)setupViews
{
    NSString *urlStr = @"http://tencent-marisa.iqing.com/index.html?gid=1&token=2b8f2e3e0d0373617f262888516b22a31ee91d68&frame=webview";
    NSLog(@"webURL = %@",urlStr);
    NSString *sendToken = [NSString stringWithFormat:@"backToApp"];
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    self.config = [[WKWebViewConfiguration alloc] init];
    
    //配置js(这个很重要，不配置的话，下面注入的js是不起作用的)
    //WeakScriptMessageDelegate这个类是用来避免循环引用的
    [_config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"backToApp"];
    //注入js
    [_config.userContentController addUserScript:wkUScript];
    _config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        _config.mediaTypesRequiringUserActionForPlayback = false;
    } else {
        // Fallback on earlier versions
    }
    NSLog(@"self.view = %@",NSStringFromCGRect(self.view.frame));
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) configuration: self.config];
    if ([UIScreen mainScreen].bounds.size.width == 812) {
        self.webView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    }
    else{
        
    }
    
    [self.webView canGoBack];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView setOpaque:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self.view addSubview:self.webView];
    
}

#pragma mark - wkwebView
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"backToApp"]) {
        //关闭演绘，返回App
        [self.navigationController popViewControllerAnimated:true];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"提示信息：%@", message);   //js的alert框的message
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
