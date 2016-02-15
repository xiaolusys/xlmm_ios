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
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    NSString *sharelink = [NSString stringWithFormat:@"%@/%@", Root_URL, url1];
    NSLog(@"link = %@", sharelink);
    NSString *content = @"小鹿美美";
    
    if ([platform isEqualToString:@"qq"]) {
        NSLog(@"qq");
        
        [UMSocialData defaultData].extConfig.qqData.url = sharelink;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];

    } else if ([platform isEqualToString:@"wxapp"]){
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"小鹿美美";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        
        
    } else if ([platform isEqualToString:@"sinawb"]){
        
        NSString *sinaContent = [NSString stringWithFormat:@"%@", sharelink];
        NSData *data = UIImagePNGRepresentation(image);
        [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:data];
    } else if ([platform isEqualToString:@"web"]){
       // NSLog(@"copy");
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        NSString *str = sharelink;
        [pab setString:str];
        if (pab == nil) {
            [SVProgressHUD showErrorWithStatus:@"请重新复制"];
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"已复制"];
        }
    } else if ([platform isEqualToString:@"qqspa"]){
        NSLog(@"zone");
        [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];

    } else if ([platform isEqualToString:@"pyq"]){
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"小鹿美美";
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
        }];
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
