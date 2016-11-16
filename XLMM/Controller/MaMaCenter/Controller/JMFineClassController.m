//
//  JMFineClassController.m
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFineClassController.h"


//@interface JMFineClassController () <UIWebViewDelegate>
//
////@property (nonatomic, strong)UIWebView *webView;
//
////@property (nonatomic, strong) NJKWebViewProgressView *progressView;
//
//@end

@implementation JMFineClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    super.baseWebView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 114);
//    NSLog(@"%@",super.baseWebView);
//    [self createWebView];

}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if ([NSString isStringEmpty:urlString]) {
        [MBProgressHUD showError:@"加载失败~"];
    }else {
        [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
}
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


@end

















