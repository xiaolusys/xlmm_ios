//
//  HuodongViewController.m
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HuodongViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "UMSocial.h"
#import "SendMessageToWeibo.h"
#import "WXApi.h"
#import "SVProgressHUD.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareForPlatform:) name:@"activityShare" object:nil];
    
    
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.diction objectForKey:@"act_link"]]];
   // http://192.168.1.31:9000/sale/promotion/xlsampleorder/
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.31:9000/sale/promotion/xlsampleorder"]];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
    
    
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shareForPlatform:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    NSLog(@"info = %@", info);
    
    NSString *param = [info objectForKey:@"param"];
    NSArray *array = [param componentsSeparatedByString:@"&"];
    NSString *platform = [array[0] componentsSeparatedByString:@"="][1];
    NSString *url = [array[1] componentsSeparatedByString:@"="][1];
    NSString *url1 = [NSString stringWithFormat:@"%@=%@&%@", url, [array[1] componentsSeparatedByString:@"="][2], array[2]];
    NSString *sharelink = [NSString stringWithFormat:@"%@/%@", Root_URL, url1];
    NSLog(@"link = %@", sharelink);
    
    if ([platform isEqualToString:@"qq"]) {
        NSLog(@"qq");
        
        
        

    } else if ([platform isEqualToString:@"wxapp"]){
        
        NSLog(@"xp");
        
        
        
    } else if ([platform isEqualToString:@"sinawb"]){
        NSLog(@"wb");
     
        
        
    } else if ([platform isEqualToString:@"web"]){
        NSLog(@"copy");
      
        
    } else if ([platform isEqualToString:@"qqspa"]){
        NSLog(@"zone");
       
        
        

    } else if ([platform isEqualToString:@"pyq"]){
       
        NSLog(@"friends");
    
    } else{
        NSLog(@"others");
    }
    
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
