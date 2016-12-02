//
//  JMFineClassController.m
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFineClassController.h"
#import "IMYWebView.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgressView.h"
#import "WebViewJavascriptBridge.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "IosJsBridge.h"
#import "JMPayShareController.h"
#import "PersonOrderViewController.h"


@interface JMFineClassController () <IMYWebViewDelegate,UIWebViewDelegate,WKUIDelegate> {
    NSString *_fineCouponTid;
}


@property (nonatomic ,strong) IMYWebView *baseWebView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic,strong) JMShareViewController *shareView;
@property (nonatomic,strong) JMShareModel *share_model;


@end


@implementation JMFineClassController
- (JMShareViewController *)shareView {
    if (!_shareView) {
        _shareView = [[JMShareViewController alloc] init];
    }
    return _shareView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    [self createWebView];
    [self loadMaMaWeb];
    
    if(self.baseWebView.usingUIWebView) {
        [self registerJsBridge];
    }
}

- (void)refreshWebView {
    if (![NSString isStringEmpty:self.urlString] && self.baseWebView != nil) {
        [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
}

- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject){
            [[JMGlobal global] hideWaitLoading];
            return ;
        }
        [self mamaWebViewData:responseObject];
    } WithFail:^(NSError *error) {
        [[JMGlobal global] hideWaitLoading];
    } Progress:^(float progress) {
    }];
}
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    resultsDict = resultsArr[0];
    NSDictionary *extraDict = resultsDict[@"extra"];
    self.urlString = extraDict[@"boutique"];
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}

- (void)createWebView {
//    kWeakSelf
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
//    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [self.navigationController.navigationBar addSubview:self.progressView];
    
//    NSString *titleStr = @"返回刷新";
//    CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
//    [button addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:titleStr forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14.];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.delegate = self;
    self.baseWebView.viewController = self;
//    self.baseWebView.progressBlock = ^(double estimatedProgress) {
//        [weakSelf.progressView setProgress:estimatedProgress animated:YES];
//    };
    [self.view addSubview:self.baseWebView];
    [[JMGlobal global] showWaitLoadingInView:self.baseWebView];
    
}
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
    [[JMGlobal global] hideWaitLoading];
}
- (void)webViewDidStartLoad:(IMYWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    [[JMGlobal global] hideWaitLoading];
}

#pragma mark - 注册js bridge供h5页面调用
- (void)registerJsBridge {
    if (_bridge) {
        NSLog(@"Already reg!");
        return ;
    }
    NSLog(@"registerJsBridge!");
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.baseWebView.realWebView];
    
    [self.bridge setWebViewDelegate:self];
    
    // 商品详情
    [self.bridge registerHandler:@"jumpToNativeLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self jsLetiOSWithData:data callBack:responseCallback];
    }];
    // 支付
    [self.bridge registerHandler:@"callNativePurchase" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        NSDictionary *dataDic = data[@"charge"];
        NSString *tidString = [NSString stringWithFormat:@"%@",dataDic[@"order_no"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fineCouponTid" object:tidString];
        [JumpUtils jumpToCallNativePurchase:dataDic Tid:tidString viewController:self];
        //        NSDictionary *para = [self dictionaryWithJsonString:data];
        //        NSDictionary *dataDic = para[@"charge"];
        //        NSString *tidString = [NSString stringWithFormat:@"%@",dataDic[@"order_no"]];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"fineCouponTid" object:tidString];
        //        [JumpUtils jumpToCallNativePurchase:dataDic Tid:tidString viewController:self];
    }];
    
    /**
     *   统一的分享接口，注意这个jsbridge实现逻辑错误，需要重新按照接口文档的参数来重写此函数。
     */
    [self.bridge registerHandler:@"callNativeUniShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeUniShareFunc");
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            [self universeShare:data];
        }
    }];
    /**
     *   进入购物车  -- 判断是否登录
     */
    [self.bridge registerHandler:@"jumpToNativeLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            [self jsLetiOSWithData:data callBack:responseCallback];
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
        [self.navigationController popViewControllerAnimated:YES];
    }];
    /**
     *  老的分享接口，带活动id
     */
    [self.bridge registerHandler:@"callNativeShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeShareFunc");
//        [self shareForPlatform:data];
    }];
    /**
     *  详情界面加载
     */
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BOOL isLoading = [data[@"isLoading"] boolValue];
        if (!isLoading) {
            [MBProgressHUD hideHUDForView:self.view];
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
- (void)jsLetiOSWithData:(id )data callBack:(WVJBResponseCallback)block {
    NSString *target_url = [data objectForKey:@"target_url"];
    [JumpUtils jumpToLocation:target_url viewController:self];
}
- (void)universeShare:(NSDictionary *)data {
    //    if([_webDiction[@"type_title"] isEqualToString:@"ProductDetail"]){
    //        [self resolveProductShareParam:data];
    //    }
    self.shareView.model = [[JMShareModel alloc] init];
    self.shareView.model.share_type = [data objectForKey:@"share_type"];
    
    self.shareView.model.share_img = [data objectForKey:@"share_icon"]; //图片
    self.shareView.model.desc = [data objectForKey:@"share_desc"]; // 文字详情
    
    self.shareView.model.title = [data objectForKey:@"share_title"]; //标题
    self.shareView.model.share_link = [data objectForKey:@"link"];
    //    self.shareView.model = self.share_model;
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.shareView WithBlock:^(UIView *maskView) {
    }];
    self.shareView.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };
    
}





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"JMFineClassController"];
    [[JMGlobal global] hideWaitLoading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponTid:) name:@"fineCouponTid" object:nil];
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick beginLogPageView:@"JMFineClassController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancleZhifu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fineCouponTid" object:nil];
}
- (void)paySuccessful {
    NSLog(@"支付成功");
    [MobClick event:@"fineCoupon_buySuccess"];
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = _fineCouponTid;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popview {
    NSLog(@"支付取消/支付失败");
    [MobClick event:@"fineCoupon_buyCancel_buyFail"];
    PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
    orderVC.index = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)couponTid:(NSNotification *)sender {
    _fineCouponTid = sender.object;
}






@end

















//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 113);
//
//    [[JMGlobal global] showWaitLoadingInView:self.baseWebView];
//    self.baseWebView.delegate = self;
////    NSLog(@"%@",super.baseWebView);
////    [self createWebView];
//    [self loadMaMaWeb];
//
//}
//- (void)loadMaMaWeb {
//    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject){
//            [[JMGlobal global] hideWaitLoading];
//            return ;
//        }
//        [self mamaWebViewData:responseObject];
//    } WithFail:^(NSError *error) {
//        [[JMGlobal global] hideWaitLoading];
//    } Progress:^(float progress) {
//    }];
//}
//- (void)mamaWebViewData:(NSDictionary *)mamaDic {
//    NSArray *resultsArr = mamaDic[@"results"];
//    NSDictionary *resultsDict = [NSDictionary dictionary];
//    resultsDict = resultsArr[0];
//    NSDictionary *extraDict = resultsDict[@"extra"];
//    self.urlString = extraDict[@"boutique"];
//    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
//
//}
//
////- (void)setUrlString:(NSString *)urlString {
////    _urlString = urlString;
////    if ([NSString isStringEmpty:urlString]) {
////        [MBProgressHUD showError:@"加载失败~"];
////    }else {
////        [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
////    }
////}
//- (void)backClick:(UIButton *)button {
//
//}
//- (void)webViewDidStartLoad:(IMYWebView *)webView {
//}
//- (void)webViewDidFinishLoad:(IMYWebView *)webView {
//    [[JMGlobal global] hideWaitLoading];
//}
//- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
//    [[JMGlobal global] hideWaitLoading];
//}
//- (void)createWebView {
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 114)];
//    self.webView.backgroundColor = [UIColor whiteColor];
//    self.webView.delegate = self;
//    self.webView.scalesPageToFit = YES;
//
//    [self.view addSubview:self.webView];
//
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [MBProgressHUD showLoading:@"小鹿努力加载中~" ToView:self.view];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [MBProgressHUD hideHUDForView:self.view];
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [MBProgressHUD hideHUDForView:self.view];
//    [MBProgressHUD showError:@"加载失败~"];
//    //    [self backClickAction];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    //    self.webView = nil;
//}
