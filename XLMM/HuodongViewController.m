//
//  HuodongViewController.m
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HuodongViewController.h"
#import "UIViewController+NavigationBar.h"

@interface HuodongViewController ()<UIWebViewDelegate>

@end

@implementation HuodongViewController


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
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:[self.diction objectForKey:@"title"] selecotr:@selector(backClicked:)];
    
    
    
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.diction objectForKey:@"act_link"]]];
   // http://192.168.1.31:9000/sale/promotion/xlsampleorder/
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.31:9000/sale/promotion/xlsampleorder"]];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
    
    
}

- (void)shareForPlatform:(NSString *)platform andLink:(NSString *)url{
    
    if ([platform isEqualToString:@"qq"]) {
        NSLog(@"qq");
    } else if ([platform isEqualToString:@"wx"]){
        NSLog(@"wx");
    } else if ([platform isEqualToString:@"wb"]){
        NSLog(@"wb");
    } else if ([platform isEqualToString:@"copy"]){
        NSLog(@"copy");
    } else if ([platform isEqualToString:@"zone"]){
        NSLog(@"zone");
    } else if ([platform isEqualToString:@"friends"]){
        NSLog(@"platform");
    } else{
        NSLog(@"others");
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    NSLog(@"scheme = %@", scheme);
    NSLog(@"host = %@", url.host);
    
    if ([scheme isEqualToString:@"color"]) {
        //self.toolbar.tintColor = [self colorWithHexString:url.host];
    }
    
    return YES;
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
