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
#import "UIImage+ImageWithSelectedView.h"


@interface HuodongViewController ()<UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UIWebView *shareWebView;
@property (nonatomic, strong) UIWebView *erweimaShareWebView;



@end

@implementation HuodongViewController{
    UIImage *shareImage;
    NSString *content;
    NSString *shareTitle;
    UIImage *newshareImage;
    UIImage *webViewImage;
    
    NSString *shareType;
    
    NSString *shareUrllink;
    
    
    
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
    self.shareWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.erweimaShareWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
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
    self.shareWebView =nil;
    webViewImage = nil;
    self.webView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shareForPlatform:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    //NSLog(@"info = %@", info);
    
   // http://dev.xiaolumeimei.com/rest/v1/pmt/free_order/get_share_content
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/free_order/get_share_content", Root_URL];
    NSLog(@"string = %@", string);
    
    
    
    
    NSString *param = [info objectForKey:@"param"];
    NSArray *array = [param componentsSeparatedByString:@"&"];
    NSString *platform = [array[0] componentsSeparatedByString:@"="][1];
    NSString *url = [array[1] componentsSeparatedByString:@"="][1];
    NSString *url1;
    NSString *sharelink;
    shareType = platform;
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
    shareUrllink = sharelink;
   
    
    NSDictionary *param0 = @{@"ufrom":platform};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
    
  
    
    
    
    [manager POST:string parameters:param0
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
             NSLog(@"JSON: %@", responseObject);
              //  active_dec   //  link_qrcode   title
              shareTitle = [responseObject objectForKey:@"title"];
              NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"link_qrcode"]];
              NSLog(@"imageUrl = %@", imageurl);
              newshareImage = [UIImage imagewithURLString:imageurl];
              content = [responseObject objectForKey:@"active_dec"];
              shareImage = [UIImage imagewithURLString:[responseObject objectForKey:@"share_img"]];
              
              
              if ([platform isEqualToString:@"qq"]) {
                  NSLog(@"qq");
                  
                  [UMSocialData defaultData].extConfig.qqData.url = sharelink;
                  [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                  }];
                  
                  
              }else if ([platform isEqualToString:@"sinawb"]){
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
                  
                  [SVProgressHUD showWithStatus:@"正在下载二维码..."];
                  //                  isWXFriends = NO;
                  NSLog(@"0000 = %@", [responseObject objectForKey:@"qrcode_link"]);
                  [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
                  
                  
              } else if ([platform isEqualToString:@"qqspa"]){
                  NSLog(@"zone");
                  
                  [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
                  [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
                  
                  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image: shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                  }];
                  
                  
              } else if ([platform isEqualToString:@"wxapp"]){
                  if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                      NSLog(@"wx");
                      [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                      [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
                      
                      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                          
                      }];

                  } else {
                      
                      [SVProgressHUD showWithStatus:@"正在生成快照..."];
                      //                  isWXFriends = NO;
                      [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];

                      
                  }
                  
                  
                  
                  
                  
              }  else if ([platform isEqualToString:@"pyq"]){
                  
                  NSLog(@"friends");
                  
                  if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                      [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
                      [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                      
                      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                          
                      }];
                  } else{
                      
                      [SVProgressHUD showWithStatus:@"正在生成快照..."];
                      //                  isWXFriends = NO;
                      [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];

                      
                  }
                  
                  
                  
                  
              } else{
                  
                  NSLog(@"others");
              }


              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              
          }];

    
    
}



- (void)createKuaiZhaoImagewithlink:(NSString *)link{
    NSLog(@"link = %@", link);
    
    
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.shareWebView loadRequest:request];
    self.shareWebView.delegate = self;
    self.shareWebView.scalesPageToFit = YES;
    self.shareWebView.tag = 888;
}



- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UIWebView代理

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (webView.tag != 888) {
        
        return;
        
    }
    if (webView.isLoading) {
        return;
    }
   
    
    webViewImage = [UIImage imagewithWebView:self.shareWebView];
    webViewImage = [UIImage imagewithWebView:self.shareWebView];
    
    [SVProgressHUD dismiss];
    if ([shareType isEqualToString:@"pyq"]) {
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
        }];
    } else if ([shareType isEqualToString:@"wxapp"]) {
        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:webViewImage socialUIDelegate:self];
        //        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else if ([shareType isEqualToString:@"web"]){
        // 保存本地二维码
  
        
        UIImageWriteToSavedPhotosAlbum(webViewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        webViewImage = nil;
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
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
