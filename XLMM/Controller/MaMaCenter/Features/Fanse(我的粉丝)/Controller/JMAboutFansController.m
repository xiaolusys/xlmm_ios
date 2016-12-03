//
//  JMAboutFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAboutFansController.h"
#import "IMYWebView.h"

@interface JMAboutFansController ()

@property (nonatomic ,strong) IMYWebView *baseWebView;

@end

@implementation JMAboutFansController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"关于粉丝" selecotr:@selector(backBtnClicked:)];
    
    NSString *loadLink = self.fansUrlString;
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.viewController = self;
    [self.view addSubview:self.baseWebView];
    
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadLink]]];
    
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end













