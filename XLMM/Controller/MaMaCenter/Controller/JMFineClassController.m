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


@interface JMFineClassController () <IMYWebViewDelegate>

@property (nonatomic ,strong) IMYWebView *baseWebView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@end


@implementation JMFineClassController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    [self createWebView];
    [self loadMaMaWeb];
    
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
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.delegate = self;
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









- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMFineClassController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMFineClassController"];
    [[JMGlobal global] hideWaitLoading];
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
