//
//  JMSocialActivityController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSocialActivityController.h"
#import "IMYWebView.h"
#import <WebKit/WebKit.h>


@interface JMSocialActivityController () <IMYWebViewDelegate>


@property (nonatomic ,strong) IMYWebView *baseWebView;

@end

@implementation JMSocialActivityController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMSocialActivityController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMSocialActivityController"];
    [[JMGlobal global] hideWaitLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"论坛" selecotr:nil];
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
    self.urlString = extraDict[@"forum"];
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}
- (void)refreshWebView {
    if (![NSString isStringEmpty:self.urlString] && self.baseWebView != nil) {
        [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
}

- (void)createWebView {
//    NSString *titleStr = @"返回刷新";
//    CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
//    [button addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:titleStr forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14.];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.delegate = self;
    self.baseWebView.viewController = self;
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









@end










































