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
#import "AFNetworking.h"


@interface HuodongViewController ()<UIWebViewDelegate, UMSocialUIDelegate>

@end

@implementation HuodongViewController{
    UIImage *shareImage;
    NSString *content;
    NSString *shareTitle;
    
}


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
    shareImage = [UIImage imageNamed:@"icon-xiaolu.png"];
    content = @"小鹿美美";
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.diction objectForKey:@"act_link"]]];
    NSLog(@"webViewurl = %@", [self.diction objectForKey:@"act_link"]);
   // http://192.168.1.31:9000/sale/promotion/xlsampleorder/
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.31:9000/sale/promotion/xlsampleorder"]];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
    
    
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shareForPlatform:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    //NSLog(@"info = %@", info);
    
   // http://dev.xiaolumeimei.com/rest/v1/pmt/free_order/get_share_content
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/free_order/get_share_content", Root_URL];
  //  NSLog(@"string = %@", string);
    
    
    
    
    NSString *param = [info objectForKey:@"param"];
    NSArray *array = [param componentsSeparatedByString:@"&"];
    NSString *platform = [array[0] componentsSeparatedByString:@"="][1];
    NSString *url = [array[1] componentsSeparatedByString:@"="][1];
    NSString *url1;
    NSString *sharelink;
    @try {
        url1 = [NSString stringWithFormat:@"%@=%@&%@", url, [array[1] componentsSeparatedByString:@"="][2], array[2]];
        sharelink = [NSString stringWithFormat:@"%@/%@", Root_URL, url1];

        NSLog(@"link = %@", sharelink);

        
    }
    @catch (NSException *exception) {
     //   NSLog(@"exception = %@", exception);
        sharelink = nil;
    }
    @finally {
        
    }
    
    NSLog(@"link = %@", sharelink);
   
    
    NSDictionary *param0 = @{@"ufrom":platform};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
    
  
    
    
    
    [manager POST:string parameters:param0
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
            //  NSLog(@"JSON: %@", responseObject);
              //  active_dec   //  link_qrcode   title
              shareTitle = [responseObject objectForKey:@"title"];
              NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"link_qrcode"]];
          //    NSLog(@"imageUrl = %@", imageurl);
              shareImage = [UIImage imagewithURLString:imageurl];
              content = [responseObject objectForKey:@"active_dec"];
              
              if ([platform isEqualToString:@"qq"]) {
                  NSLog(@"qq");
                  
                  [UMSocialData defaultData].extConfig.qqData.url = sharelink;
                  [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                  }];
                  
                  
              } else if ([platform isEqualToString:@"wxapp"]){
                  
                  NSLog(@"wx");
                  [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                  [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
                  
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                      
                  }];
                  
                  
                  
                  
              } else if ([platform isEqualToString:@"sinawb"]){
                  NSLog(@"wb");
                  NSString *sinaContent = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
                  [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:UIImagePNGRepresentation(shareImage)];
                  
                  
                  
                  
              } else if ([platform isEqualToString:@"web"]){
                  NSLog(@"copy");
                  UIPasteboard *pab = [UIPasteboard generalPasteboard];
                  NSString *str = sharelink;
                  if (str == nil) {
                      [SVProgressHUD showSuccessWithStatus:@"复制失败"];
                      return ;  
                  }
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
                  [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
                  
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image: shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                  }];
                  
                  
              } else if ([platform isEqualToString:@"pyq"]){
                  
                  NSLog(@"friends");
                  
                  [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
                  [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                  
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                      
                  }];
                  
                  
              } else{
                  
                  NSLog(@"others");
              }

              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              
          }];

    
    
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
