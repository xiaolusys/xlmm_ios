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
#import "YoumengShare.h"
#import "NSString+URL.h"
#import "UIImage+UIImageExt.h"
#import "WebViewJavascriptBridge.h"
#import "MMDetailsViewController.h"



@interface HuodongViewController ()<UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UIWebView *shareWebView;
@property (nonatomic, strong) UIWebView *erweimaShareWebView;

//遮罩层
@property (nonatomic, strong) UIView *shareBackView;
//分享页面
@property (nonatomic, strong) YoumengShare *youmengShare;

@property (nonatomic,assign)BOOL isPic;
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)UIImage *imageData;
@property (nonatomic, strong)NSData *imageD;
@property (nonatomic, strong)NSString *kuaizhaoLink;
@property (nonatomic, assign)BOOL isWeixin;
@property (nonatomic, assign)BOOL isWeixinFriends;
@property (nonatomic, assign)BOOL isCopy;

@property (nonatomic, strong)WebViewJavascriptBridge* bridge;


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

- (YoumengShare *)youmengShare {
    if (!_youmengShare) {
        self.youmengShare = [[YoumengShare alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _youmengShare;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //与js交互代码。。
    /*
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    */
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)tiaozhuan:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *ID = [userInfo objectForKey:@"productID"];
   
    
    MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:ID isChild:NO];
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:[self.diction objectForKey:@"title"] selecotr:@selector(backClicked:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuan:) name:@"productTransate" object:nil];
//    [[NSNotificationCenter defaultCenter] ]
    
    
    
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    label.text = [self.diction objectForKey:@"title"];
//    label.textColor = [UIColor blackColor];
//    label.font = [UIFont systemFontOfSize:16];
//    label.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = label;
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image2.png"]];
//    imageView.frame = CGRectMake(0, 14, 16, 16);
//    [button addSubview:imageView];
////    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationItem.leftBarButtonItem = leftItem;


    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareIconImage2.png"]];
    imageView1.frame = CGRectMake(25, 13, 20, 20);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
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



- (void)rightBarButtonAction {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/free_order/get_share_content", Root_URL];
    NSLog(@"string = %@", string);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        [self addShareView:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//分享视图增加
- (void)addShareView:(NSDictionary *)dicShare {
    NSString *type = dicShare[@"share_type"];
    if ([type isEqualToString:@"link"]) {
        self.isPic = NO;
    }else {
        self.isPic = YES;
    }
    self.titleStr = dicShare[@"title"];
    self.url = dicShare[@"share_link"];
    
    self.kuaizhaoLink = dicShare[@"qrcode_link"];
    
    NSString *imageUrlString = dicShare[@"share_img"];
    NSData *imageData = nil;
    do {
        NSLog(@"image = %@", [imageUrlString URLEncodedString]);
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageUrlString URLEncodedString]]];
        if (imageData != nil) {
            break;
        }
        
    } while (YES);
    UIImage *image = [UIImage imageWithData:imageData];
    image = [[UIImage alloc] scaleToSize:image size:CGSizeMake(300, 400)];
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.8);
    UIImage *newImage = [UIImage imageWithData:imagedata];
    self.imageD = imageData;
    self.imageData = newImage;
    
    self.shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.shareBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareBackView];
    [self.shareBackView addSubview:self.youmengShare];
    self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    self.youmengShare.snapshotBtn.hidden = YES;
    self.youmengShare.friendsSnaoshotBtn.hidden = YES;
    
    // 点击分享后弹出自定义的分享界面
    [UIView animateWithDuration:0.2 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240);
    }];
    
    // 分享页面事件处理
    [self.youmengShare.cancleShareBtn addTarget:self action:@selector(cancleShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.weixinShareBtn addTarget:self action:@selector(weixinShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.friendsShareBtn addTarget:self action:@selector(friendsShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqshareBtn addTarget:self action:@selector(qqshareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqspaceShareBtn addTarget:self action:@selector(qqspaceShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.weiboShareBtn addTarget:self action:@selector(weiboShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.linkCopyBtn addTarget:self action:@selector(linkCopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//    [self.youmengShare.snapshotBtn addTarget:self action:@selector(snapshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.youmengShare.friendsSnaoshotBtn addTarget:self action:@selector(friendsSnaoshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancleShareBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self.shareBackView removeFromSuperview];
    }];
}

- (void)weixinShareBtnClick:(UIButton *)btn{
    if (self.isPic) {
        //图片
        self.isWeixin = YES;
        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
        [self cancleShareBtnClick:nil];
    }else {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            //        [self hiddenNavigationView];
        }];
        
        [self cancleShareBtnClick:nil];

    }
    
}

- (void)friendsShareBtnClick:(UIButton *)btn {
    if (self.isPic) {
        //图片
        self.isWeixinFriends = YES;
        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
        
        [self cancleShareBtnClick:nil];
    }else {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            //        [self hiddenNavigationView];
            
        }];
        
        [self cancleShareBtnClick:nil];
    }
}



- (void)qqshareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@" " image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        [self hiddenNavigationView];
    }];
    
    
    [self cancleShareBtnClick:nil];
}

- (void)qqspaceShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@" " image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        [self hiddenNavigationView];
    }];
    
    [self cancleShareBtnClick:nil];
}

- (void)weiboShareBtnClick:(UIButton *)btn {
    NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.titleStr, self.url];
    [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:self.imageD];
    
    [self cancleShareBtnClick:nil];
}

- (void)linkCopyBtnClick:(UIButton *)btn {
    self.isCopy = YES;
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *str = self.url;
    [pab setString:str];
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"请重新复制"];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
    }
    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
    
    [self cancleShareBtnClick:nil];
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
    if ([shareType isEqualToString:@"pyq"] || (self.isPic && self.isWeixinFriends)) {
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
        }];
        self.isWeixin = NO;
    } else if ([shareType isEqualToString:@"wxapp"] || (self.isPic && self.isWeixin)) {
        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:webViewImage socialUIDelegate:self];
        //        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        self.isWeixinFriends = NO;
    } else if ([shareType isEqualToString:@"web"] || self.isCopy){
        // 保存本地二维码
        UIImageWriteToSavedPhotosAlbum(webViewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        self.isCopy = NO;
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的专属二维码已保存，可用微信群发200好友哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
