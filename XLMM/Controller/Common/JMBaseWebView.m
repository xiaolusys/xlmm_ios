//
//  JMBaseWebView.m
//  XLMM
//
//  Created by zhang on 16/5/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBaseWebView.h"

@interface JMBaseWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation JMBaseWebView

- (instancetype)initWithUrl:(NSString *)url Title:(NSString *)titleName {
    if (self == [super init]) {
        
        _titleName = titleName;
        
        if ((url != nil) && (url.length > 0)) {
            _urlStr = url;
        }else {
            _urlStr = @"";
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
    
}
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = [urlStr copy];
}

- (void)createWebView {
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:statusBarView];
    
    if (self.urlStr.length == 0 || [self.urlStr class] == [NSNull null]) return;

    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.webView];
    
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    
    [self.webView loadRequest:request];
    
    
    
    
    
    
    
}


@end































