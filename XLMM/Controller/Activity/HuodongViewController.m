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
#import "YouHuiQuanViewController.h"
#import "XiangQingViewController.h"
#import "MaMaPersonCenterViewController.h"
#import "PublishNewPdtViewController.h"
#import "MMCollectionController.h"
#import "UUID.h"
#import "SSKeychain.h"

#define kService [NSBundle mainBundle].bundleIdentifier
#define kAccount @"so.xiaolu.m.xiaolumeimei"

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

@property (nonatomic, strong)NSNumber *activityId;

@property (nonatomic, strong)WebViewJavascriptBridge* bridge;

@property (nonatomic, strong)NSDictionary *nativeShare;
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
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareIconImage2.png"]];
    imageView1.frame = CGRectMake(25, 13, 20, 20);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *loadStr = nil;
    if (self.diction.count == 0) {
        [self createNavigationBarWithTitle:self.titleName selecotr:@selector(backClicked:)];
        loadStr = self.eventLink;
        button1.hidden = YES;
        button1.userInteractionEnabled = NO;
        imageView1.hidden = YES;
    }else {
        [self createNavigationBarWithTitle:[self.diction objectForKey:@"title"] selecotr:@selector(backClicked:)];
        //取出活动id
        self.activityId = [self.diction objectForKey:@"id"];
        loadStr = [self.diction objectForKey:@"act_link"];
        button1.hidden = NO;
        button1.userInteractionEnabled = YES;
        imageView1.hidden = NO;
    }
    
    
    
    

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loadStr]];
    
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
    
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    [self.bridge registerHandler:@"jumpToNativeLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self jumpToJsLocation:data]; 
    }];
    
    [self.bridge registerHandler:@"callNativeShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *share_to = data[@"share_to"];
        //传的参数为空调用原生的分享
        if (share_to.length == 0) {
            self.nativeShare = data;
            [self rightBarButtonAction];
            return;
        }
        [self shareForPlatform:data];
    }];
    
    [self.bridge registerHandler:@"getNativeMobileSNCode" handler:^(id data, WVJBResponseCallback responseCallback) {
       NSString *device = [self getMobileSNCode];
        responseCallback(device);
    }];

    self.shareWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.erweimaShareWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];

    shareImage = [UIImage imageNamed:@"icon-xiaolu.png"];
    content = @"小鹿美美";
}

- (NSString *)getMobileSNCode {
    if (![SSKeychain passwordForService:kService account:kAccount]) {
        NSString *uuid = [UUID gen_uuid];
        [SSKeychain setPassword:uuid forService:kService account:kAccount];
    }
    
    NSString *devicenumber = [SSKeychain passwordForService:kService account:kAccount];
    return devicenumber;
}

- (void)rightBarButtonAction {
//    NSLog(@"===========data======%@", self.nativeShare);
    NSNumber *activityID = nil;
    if (self.nativeShare == nil) {
        activityID = self.activityId;
    }else {
        activityID = self.nativeShare[@"active_id"];
    }
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activityID];
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
    [SVProgressHUD dismiss];
    NSString *type = dicShare[@"share_type"];
    if ([type isEqualToString:@"link"]) {
        self.isPic = NO;
    }else {
        self.isPic = YES;
    }
    self.titleStr = [dicShare objectForKey:@"title"];
    content = [dicShare objectForKey:@"active_dec"];
    
    self.url = dicShare[@"share_link"];
    
    self.kuaizhaoLink = dicShare[@"share_link"];
    
    NSString *imageUrlString = dicShare[@"share_icon"];
//    NSData *imageData = nil;
//    do {
//        NSLog(@"image = %@", [imageUrlString URLEncodedString]);
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageUrlString URLEncodedString]]];
//        if (imageData != nil) {
//            break;
//        }
//        if (imageUrlString.length == 0 || [NSNull class] == [imageUrlString class]) {
//            break;
//        }
//        
//    } while (YES);
//    UIImage *image = [UIImage imageWithData:imageData];
//    image = [[UIImage alloc] scaleToSize:image size:CGSizeMake(300, 400)];
//    NSData *imagedata = UIImageJPEGRepresentation(image, 0.8);
//    UIImage *newImage = [UIImage imageWithData:imagedata];
//    self.imageD = imageData;
//    self.imageData = newImage;
//    shareImage = [UIImage imagewithURLString:[responseObject objectForKey:@"share_icon"]];
    self.imageData = [UIImage imagewithURLString:imageUrlString];
    
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
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"https://www.baidu.com";
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            //        [self hiddenNavigationView];
            
        }];
        
        [self cancleShareBtnClick:nil];
    }
}



- (void)qqshareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        [self hiddenNavigationView];
    }];
    
    
    [self cancleShareBtnClick:nil];
}

- (void)qqspaceShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        [self hiddenNavigationView];
    }];
    
    [self cancleShareBtnClick:nil];
}

- (void)weiboShareBtnClick:(UIButton *)btn {
    NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.titleStr, self.url];
    [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:UIImagePNGRepresentation(self.imageData)];
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

- (void)shareForPlatform:(NSDictionary *)data{
    
    NSNumber *activeid = data[@"active_id"];
    NSString *platform = data[@"share_to"];
//    NSString *platform = @"web";
    
    if ([activeid integerValue] == 0) {
        activeid = self.activityId;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
//    NSLog(@"string----%@", string);
    
//    NSString *param = @"";
//    NSArray *array = [param componentsSeparatedByString:@"&"];
//    NSString *platform = data[@"share_to"];
//    NSString *url = [array[1] componentsSeparatedByString:@"="][1];
//    NSString *url1;
   
    shareType = data[@"share_to"];
    //shareType = @"web";
    
//    @try {
//        url1 = [NSString stringWithFormat:@"%@=%@&%@", url, [array[1] componentsSeparatedByString:@"="][2], array[2]];
//        sharelink = [NSString stringWithFormat:@"%@/%@", Root_URL, url1];
//        NSLog(@"link = %@", sharelink);
//    }
//    @catch (NSException *exception) {
//     //   NSLog(@"exception = %@", exception);
//        sharelink = nil;
//    }
//    @finally {
//        
//    }
    
//    NSLog(@"link = %@", sharelink);
//    shareUrllink = sharelink;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        shareTitle = [responseObject objectForKey:@"title"];
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"link_qrcode"]];
        
        
//        NSString *imageUrlString = dicShare[@"share_icon"];
//        NSData *imageData = nil;
//        do {
//            NSLog(@"image = %@", [imageUrlString URLEncodedString]);
//            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageUrlString URLEncodedString]]];
//            if (imageData != nil) {
//                break;
//            }
//            if (imageUrlString.length == 0 || [NSNull class] == [imageUrlString class]) {
//                break;
//            }
//            
//        } while (YES);
//        UIImage *image = [UIImage imageWithData:imageData];
//        image = [[UIImage alloc] scaleToSize:image size:CGSizeMake(300, 400)];
//        NSData *imagedata = UIImageJPEGRepresentation(image, 0.8);
//        UIImage *newImage = [UIImage imageWithData:imagedata];
//        self.imageD = imageData;
//        self.imageData = newImage;
        
        
        newshareImage = [UIImage imagewithURLString:imageurl];
        content = [responseObject objectForKey:@"active_dec"];
        shareImage = [UIImage imagewithURLString:[responseObject objectForKey:@"share_icon"]];
        NSString *sharelink = [responseObject objectForKey:@"share_link"];
        
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
        self.isWeixinFriends = NO;
    } else if ([shareType isEqualToString:@"wxapp"] || (self.isPic && self.isWeixin)) {
        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:webViewImage socialUIDelegate:self];
        //        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        self.isWeixin = NO;
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

#pragma mark 解析targeturl 跳转到不同的界面
- (void)jumpToJsLocation:(NSDictionary *)dic{
//    NSLog(@"dic = %@", dic);
//    NSString *allStr = [dic objectForKey:@"target_url"];
//    
//    NSArray *arr = [target_url componentsSeparatedByString:@"?"];
    
//    NSString *target_url = arr[0];
    
    NSString *target_url = [dic objectForKey:@"target_url"];
    
    if (target_url == nil) {
        return;
    }
    
    //跳转到每日上新－－－－
    NSLog(@"target_url = %@", target_url);
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_today"]) {
        NSLog(@"跳到今日上新");
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"today"}];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_previous"]){
        NSLog(@"跳到昨日推荐");
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"previous"}];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/childlist"]){
        NSLog(@"跳到潮童专区");
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"child"}];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/ladylist"]){
        NSLog(@"跳到时尚女装");
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"woman"}];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/usercoupons/method"]){
        NSLog(@"跳转到用户未过期优惠券列表");
        
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        [self.navigationController pushViewController:youhuiVC animated:YES];
        
        
        
    }  else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_home"]){
        
        //  跳转到小鹿妈妈界面。。。
        MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:ma animated:YES];
        
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_0day"]){
        
        NSLog(@"跳转到小鹿妈妈每日上新");
        
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [self.navigationController pushViewController:publish animated:YES];
        
    }else {
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        
        NSString *parameter = [components lastObject];
        NSArray *params = [parameter componentsSeparatedByString:@"="];
        NSString *firstparam = [params firstObject];
        if ([firstparam isEqualToString:@"model_id"]) {
            NSLog(@"跳到集合页面");
            NSLog(@"model_id = %@", [params lastObject]);
            
            
            MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[params lastObject] isChild:NO];
            
            [self.navigationController pushViewController:collectionVC animated:YES];
            
            
            
        } else if ([firstparam isEqualToString:@"product_id"]){
            NSLog(@"跳到商品详情");
            NSLog(@"product_id = %@", [params lastObject]);
            
            MMDetailsViewController *details = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:[params lastObject] isChild:NO];
            [self.navigationController pushViewController:details animated:YES];
            
            
        } else if ([firstparam isEqualToString:@"trade_id"]){
            NSLog(@"跳到订单详情");
            NSLog(@"trade_id = %@", [params lastObject]);
            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
            //http://m.xiaolu.so/rest/v1/trades/86412/details
            
            // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
            xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, [params lastObject]];
            NSLog(@"url = %@", xiangqingVC.urlString);
            
            
            [self.navigationController pushViewController:xiangqingVC animated:YES];
            
            
        } else {
            NSLog(@"跳到H5首页");
        }
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
