//
//  CommonWebViewViewController.m
//  XLMM
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CommonWebViewViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"

@interface CommonWebViewViewController ()
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation CommonWebViewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.titleName selecotr:@selector(backClicked:)];
    
    if (self.loadLink.length == 0 || [self.loadLink class] == [NSNull null]) return;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadLink]]];
    
    [self updateUserAgent];
    
    
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUserAgent{
    //get the original user-agent of webview
    NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    if(oldAgent == nil) return;
    
    //add my info to the new agent
    if((oldAgent != nil) && ([oldAgent containsString:@"xlmm;"]))
        return;
    NSString *newAgent = [oldAgent stringByAppendingString:@"; xlmm;"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
