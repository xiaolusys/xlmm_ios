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
#import "JumpUtils.h"
#import "IosJsBridge.h"
#import "JMPayShareController.h"
#import "JMOrderListController.h"
#import "JMRegisterJS.h"
#import "JMEmptyView.h"
#import "JMRootTabBarController.h"


@interface JMFineClassController () <IMYWebViewDelegate,UIWebViewDelegate,WKUIDelegate> {
    NSString *_fineCouponTid;
}

@property (nonatomic ,strong) IMYWebView *baseWebView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic,strong) JMShareViewController *shareView;
@property (nonatomic,strong) JMShareModel *share_model;
@property (nonatomic, strong) JMEmptyView *empty;

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    
    [self createWebView];
    [self emptyView];
    [self loadMaMaWeb];
    
    if(self.baseWebView.usingUIWebView) {
//        [JMNotificationCenter addObserver:self selector:@selector(registerJsBridge) name:@"registerJsBridge" object:nil];
        [self registerJsBridge];
    }
}
- (void)refreshWebView {
    if (![NSString isStringEmpty:self.urlString] && self.baseWebView != nil) {
        [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
}
- (void)refreshLoadMaMaWeb {
    [self loadMaMaWeb];
}
- (void)loadMaMaWeb {
    [[JMGlobal global] showWaitLoadingInView:self.baseWebView];
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject){
            [[JMGlobal global] hideWaitLoading];
            self.empty.hidden = NO;
            return ;
        }
        self.empty.hidden = YES;
        [self mamaWebViewData:responseObject];
    } WithFail:^(NSError *error) {
        [[JMGlobal global] hideWaitLoading];
        self.empty.hidden = NO;
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
//    self.baseWebView.cs_h = 0.f;
}

- (void)createWebView {
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20 - kAppTabBarHeight) usingUIWebView:NO];
    self.baseWebView.backgroundColor = [UIColor clearColor];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.delegate = self;
    
    self.baseWebView.viewController = self;
//    self.baseWebView.progressBlock = ^(double estimatedProgress) {
//        [weakSelf.progressView setProgress:estimatedProgress animated:YES];
//    };
    [self.view addSubview:self.baseWebView];
}
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
//    self.empty.hidden = NO;
//    [[JMGlobal global] hideWaitLoading];
}
- (void)webViewDidStartLoad:(IMYWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    self.empty.hidden = YES;
//    self.baseWebView.cs_h = SCREENHEIGHT - 20 - kAppTabBarHeight;
    [[JMGlobal global] hideWaitLoading];
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 300) / 2, SCREENWIDTH, 300) Title:@"~~(>_<)~~" DescTitle:@"网络加载失败~!" BackImage:@"netWaring" InfoStr:@"重新加载"];
    [self.view addSubview:self.empty];
    self.empty.hidden = YES;
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            kStrongSelf
            strongSelf.empty.hidden = YES;
            [strongSelf loadMaMaWeb];
        }
    };
}
#pragma mark - 注册js bridge供h5页面调用
- (void)registerJsBridge {
    JMRegisterJS *regis = [[JMRegisterJS alloc] init];
    [regis registerJSBridgeBeforeIOSSeven:self WebView:self.baseWebView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"JMFineClassController"];
    self.navigationController.navigationBarHidden = YES;
    [JMNotificationCenter addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(couponTid:) name:@"fineCouponTid" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick beginLogPageView:@"JMFineClassController"];
    [JMNotificationCenter removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter removeObserver:self name:@"CancleZhifu" object:nil];
    [JMNotificationCenter removeObserver:self name:@"fineCouponTid" object:nil];
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
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 1;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)couponTid:(NSNotification *)sender {
    _fineCouponTid = sender.object;
}
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end









//     清除缓存
//WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
//[dataStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
//    for (WKWebsiteDataRecord *recird in records) {
//        //            if ([recird.displayName containsString:@""]) {
//        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:recird.dataTypes forDataRecords:@[recird] completionHandler:^{
//            NSLog(@"Cookise for %@ deleted successfully",recird.displayName);
//        }];
//        //            }
//    }
//}];









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
