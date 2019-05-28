//
//  JMRegisterJS.m
//  XLMM
//
//  Created by zhang on 16/12/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRegisterJS.h"
#import "WebViewController.h"
#import "IMYWebView.h"
#import "WebViewJavascriptBridge.h"
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "IosJsBridge.h"
#import "JMRootTabBarController.h"



@interface JMRegisterJS () <UIWebViewDelegate>

@property (nonatomic, strong)WebViewJavascriptBridge *bridge;

@end

@implementation JMRegisterJS

+ (instancetype)defaultRegister {
    static dispatch_once_t onceToken;
    static JMRegisterJS *registerJS = nil;
    dispatch_once(&onceToken, ^{
        registerJS = [[JMRegisterJS alloc] init];
    });
    return registerJS;
}

- (void)registerJSBridgeBeforeIOSSeven:(UIViewController *)webVC WebView:(IMYWebView *)baseWebView {
    if (self.bridge) {
        return ;
    }
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:baseWebView.realWebView];
    [self.bridge setWebViewDelegate:self];
    [WebViewJavascriptBridge enableLogging];

    // 商品详情
    [self.bridge registerHandler:@"jumpToNativeLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self jsLetiOSWithData:data callBack:responseCallback WebViewController:webVC];
    }];
    // 支付
    [self.bridge registerHandler:@"callNativePurchase" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        NSDictionary *dataDic = data[@"charge"];
        NSString *tidString = [NSString stringWithFormat:@"%@",dataDic[@"order_no"]];
        [JMNotificationCenter postNotificationName:@"fineCouponTid" object:tidString];
        [JumpUtils jumpToCallNativePurchase:dataDic Tid:tidString viewController:webVC];
    }];
    
    /**
     *   统一的分享接口，注意这个jsbridge实现逻辑错误，需要重新按照接口文档的参数来重写此函数。
     */
    [self.bridge registerHandler:@"callNativeUniShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeUniShareFunc");
        BOOL login = [JMUserDefaults boolForKey:@"login"];
        if (login == NO) {
            [[JMGlobal global] showLoginViewController];
            return;
        }else {
//            [self universeShare:data];
            [IosJsBridge universeShare:webVC para:data];
        }
    }];
    /**
     *   进入购物车  -- 判断是否登录
     */
    [self.bridge registerHandler:@"jumpToNativeLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL login = [JMUserDefaults boolForKey:@"login"];
        if (login == NO) {
            [[JMGlobal global] showLoginViewController];
            return;
        }else {
            [self jsLetiOSWithData:data callBack:responseCallback WebViewController:webVC];
        }
    }];
    
    [self.bridge registerHandler:@"getNativeMobileSNCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *device = [IosJsBridge getMobileSNCode];
        responseCallback(device);
    }];
    /**
     *  返回按钮
     */
    [self.bridge registerHandler:@"callNativeBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [webVC.navigationController popViewControllerAnimated:YES];
    }];
    /**
     *  返回主页
     */
    [self.bridge registerHandler:@"callNativeBackToHome" handler:^(id data, WVJBResponseCallback responseCallback) {
        [webVC.navigationController popViewControllerAnimated:YES];
    }];
    
    
    /**
     *  老的分享接口，带活动id
     */
    [self.bridge registerHandler:@"callNativeShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeShareFunc");
//        [self shareForPlatform:data];
        [IosJsBridge callNativeShareFunc:webVC para:data];
    }];
    /**
     *  详情界面加载
     */
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BOOL isLoading = [data[@"isLoading"] boolValue];
        if (!isLoading) {
            [MBProgressHUD hideHUDForView:webVC.view];
        }
    }];
    /**
     *  我的邀请加载
     */
    //    [self.bridge registerHandler:@"changeId" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        [self myInvite:data callBack:responseCallback];
    //    }];
}

/**
 *  跳转购物车
 */
- (void)jsLetiOSWithData:(id )data callBack:(WVJBResponseCallback)block WebViewController:(UIViewController *)webVC {
    NSString *target_url = [data objectForKey:@"target_url"];
    [JumpUtils jumpToLocation:target_url viewController:webVC];
}

#pragma mark 解析targeturl 跳转到不同的界面
- (void)jumpToJsLocation:(NSDictionary *)dic{
    
    NSString *target_url = [dic objectForKey:@"target_url"];
    
    if (target_url == nil) {
        return;
    }
//    [JumpUtils jumpToLocation:target_url viewController:self];
    
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
    [[JMGlobal global] hideWaitLoading];
}
- (void)webViewDidStartLoad:(IMYWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    [[JMGlobal global] hideWaitLoading];
}





@end


























































































































































