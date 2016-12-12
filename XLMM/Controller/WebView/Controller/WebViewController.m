//
//  HuodongViewController.m
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "WebViewController.h"
#import "UMSocial.h"
#import "SendMessageToWeibo.h"
#import "WXApi.h"
#import "UIImage+ImageWithSelectedView.h"
#import "UIImage+UIImageExt.h"
#import "WebViewJavascriptBridge.h"
#import "PublishNewPdtViewController.h"
#import "MMCollectionController.h"
#import "UUID.h"
#import "SSKeychain.h"
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "IMYWebView.h"
#import "Webkit/WKScriptMessage.h"
#import "IosJsBridge.h"
#import "PersonOrderViewController.h"
#import "NJKWebViewProgressView.h"
#import "JMPayShareController.h"
#import "JMRegisterJS.h"


#define USERAGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E238"
//static BOOL isLogin;
@interface WebViewController ()<UMSocialUIDelegate,WKScriptMessageHandler,IMYWebViewDelegate,UIWebViewDelegate,WKUIDelegate> {
    NSString *_fineCouponTid;
}

@property (nonatomic, strong)WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
//分享参数
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *des;
@property (nonatomic, strong)UIImage *shareImage;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, strong) UIWebView *shareWebView;
@property (nonatomic, strong) UIWebView *erweimaShareWebView;
//遮罩层
@property (nonatomic, strong) UIView *shareBackView;

@property (nonatomic, assign)BOOL isPic;
@property (nonatomic, strong)UIImage *imageData;
@property (nonatomic, copy)NSString *kuaizhaoLink;
@property (nonatomic, assign)BOOL isWeixin;
@property (nonatomic, assign)BOOL isWeixinFriends;
@property (nonatomic, assign)BOOL isCopy;

@property (nonatomic, strong)NSDictionary *nativeShare;

/**
 *  分享数据字典
 */
@property (nonatomic, strong) NSDictionary *shareDic;
/**
 *  商品ID
 */
//@property (nonatomic, copy) NSString *itemID;
/**
 *  加载快照
 */
@property (nonatomic, strong)UIImage *kuaiZhaoImage;
/**
 *  分享显示的文字
 */
@property (nonatomic,copy) NSString *content;
/**
 *  分享显示的图片
 */
@property (nonatomic, copy) NSString *imageUrlString;
/**
 *  分享的资源（链接等）
 */
@property (nonatomic, copy) NSString *urlResource;

@property (nonatomic, assign) BOOL isWXFriends;


//@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic, strong) UIImage *webViewImage;

@end

@implementation WebViewController{
    NSString *shareTitle;
    UIImage *newshareImage;
    NSString *shareType;
    NSString *shareUrllink;
    BOOL isTeamBuy;
}
- (JMShareViewController *)shareView {
    if (!_shareView) {
        _shareView = [[JMShareViewController alloc] init];
    }
    return _shareView;
}
- (void)setWebDiction:(NSMutableDictionary *)webDiction {
    _webDiction = webDiction;
    if ([webDiction isKindOfClass:[NSMutableDictionary class]] && [webDiction objectForKey:@"titleName"]) {
        self.titleName = webDiction[@"titleName"];
    }else {
    }
}
- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}

- (BOOL)isShowNavBar {
    _isShowNavBar = NO;
    return _isShowNavBar;
}
- (BOOL)isShowRightShareBtn {
    _isShowRightShareBtn = NO;
    return _isShowRightShareBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *active = _webDiction[@"type_title"];
    if ([active isEqualToString:@"teamBuySuccess"]) {
        isTeamBuy = YES;
    }else {
        isTeamBuy = NO;
    }
    if ([active isEqualToString:@"myInvite"] || [active isEqualToString:@"active"] || _isShowNavBar) {
        self.navigationController.navigationBarHidden = NO;
    }else {
        self.navigationController.navigationBarHidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponTid:) name:@"fineCouponTid" object:nil];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view];
    
}
- (void)dealloc {
    self.baseWebView = nil;
    self.progressView = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancleZhifu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fineCouponTid" object:nil];
}

- (void)paySuccessful {
    NSLog(@"支付成功");
    [MobClick event:@"fineCoupon_buySuccess"];
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = _fineCouponTid;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popview {
    NSLog(@"支付取消/支付失败");
    [MobClick event:@"fineCoupon_buyCancel_buyFail"];
    PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
    orderVC.index = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)couponTid:(NSNotification *)sender {
    _fineCouponTid = sender.object;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showLoading:@"小鹿努力加载中~" ToView:self.view];
    [MobClick event:@"activity"];
    [self createNavigationBarWithTitle:self.titleName selecotr:@selector(backClicked:)];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    kWeakSelf
    IMYWebView *baseWebView1 = [[IMYWebView alloc] initWithFrame:self.view.bounds usingUIWebView:NO];
    super.baseWebView = baseWebView1;
    self.baseWebView.progressBlock = ^(double estimatedProgress) {
        [weakSelf.progressView setProgress:estimatedProgress animated:YES];
    };
    [self.view addSubview:super.baseWebView];
    super.baseWebView.viewController = self;
    if(super.baseWebView.usingUIWebView) {
        NSLog(@"7.0 UIWebView");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerJsBridge) name:@"registerJsBridge" object:nil];
//        [self registerJsBridge];
//        self.baseWebView.delegate = self;
    }else {
        NSLog(@"bigger than8.0 WKWebView");
//        self.baseWebView.delegate = self;
    }
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    statusBarView.hidden = YES;
    self.statusBarView = statusBarView;
    
    NSString *loadStr = nil;
    NSString *active = _webDiction[@"type_title"];
    if ([active isEqualToString:@"myInvite"]) {
        super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
        self.activityId = _webDiction[@"activity_id"];
        loadStr = _webDiction[@"web_url"];
        [self loadData];
    }else if ([active isEqualToString:@"active"]){
        super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
        self.activityId = _webDiction[@"activity_id"];//[self.diction objectForKey:@"id"];
        loadStr = _webDiction[@"web_url"];//[self.diction objectForKey:@"act_link"];
        [self loadData];
    }else if ([active isEqualToString:@"mamaShop"]){
        super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
        loadStr = _webDiction[@"web_url"];
        [self loadDataMaMaShop];
    }else {
        statusBarView.hidden = NO;
        if (_isShowNavBar) {
            super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
        }else {
            super.baseWebView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20);
        }
        loadStr = _webDiction[@"web_url"];
    }
    NSLog(@"loadRequest | loadStr =  --- > %@",loadStr);
    if (![NSString isStringEmpty:loadStr]) {
        NSURL *url = [NSURL URLWithString:loadStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSLog(@"webview url=%@ NSURLRequest=%@", url, request);
        [super.baseWebView loadRequest:request];
    }else {
        [MBProgressHUD hideHUDForView:self.view];
    }
    if(_isShowRightShareBtn){
        [self createTabBarButton];
    }
    _shareImage = [UIImage imageNamed:@"icon-xiaolu.png"];
    _content = @"小鹿美美";


}


- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, self.activityId];
    NSLog(@"Shareview _urlStr=%@ self.activityId=%@", string, self.activityId);
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            return;
        }
        [self resolveActivityShareParam:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadDataMaMaShop {
    NSString *shareString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushop/customer_shop", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:shareString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            return;
        }
        [self fetchMaMaShopShare:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchMaMaShopShare:(NSDictionary *)dic {
    NSDictionary *shopInfo = dic[@"shop_info"];
    [self createNavigationBarWithTitle:shopInfo[@"name"] selecotr:@selector(backClicked:)];
    self.share_model.share_type = @"link";
    self.share_model.share_img = [shopInfo objectForKey:@"thumbnail"]; //图片
    self.share_model.desc = [shopInfo objectForKey:@"desc"]; // 文字详情
    self.share_model.title = [shopInfo objectForKey:@"name"]; //标题
    self.share_model.share_link = [shopInfo objectForKey:@"shop_link"];
    self.shareView.model = self.share_model;
}

- (void)resolveActivityShareParam:(NSDictionary *)dic {
    self.share_model.share_type = [dic objectForKey:@"share_type"];
    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.share_model.desc = [dic objectForKey:@"active_dec"]; // 文字详情
    self.share_model.title = [dic objectForKey:@"title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"share_link"];
    self.shareView.model = self.share_model;
}
#pragma mark ----- 创建导航栏按钮
- (void)createTabBarButton {
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareIconImage2.png"]];
    imageView1.frame = CGRectMake(25, 13, 20, 20);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    button1.hidden = NO;
    

    
}
#pragma mark ----- 点击分享
- (void)rightBarButtonAction {
    [MobClick event:@"webViewController_allShare"];
    if ([_webDiction[@"type_title"] isEqual:@"active"]) {
        NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%@",self.activityId]};
        [MobClick event:@"Active_share" attributes:temp_dict];
    }else if ([_webDiction[@"type_title"] isEqual:@"myInvite"]) {
//        if ([self.activityId isEqual:@38]) {
        NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%@",self.activityId]};
        [MobClick event:@"MyInvite_share" attributes:temp_dict];
//        }
    }else if ([_webDiction[@"type_title"] isEqual:@"mamaShop"]) {
        [MobClick event:@"mamaShop_share"];
    }else { }
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.shareView WithBlock:^(UIView *maskView) {
    }];
    self.shareView.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };
    
}

#pragma mark -- UIWebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"完成加载 %ld",(long)webView.tag);
    [MBProgressHUD hideHUDForView:self.view];

    if (webView.tag != 102) {
        [[JMDevice defaultDecice] cerateUserAgent];
//        [self registerJsBridge];
        return;
    }
    if (webView.isLoading) {
        return;
    }

}

#pragma mark - 注册js bridge供h5页面调用
- (void)registerJsBridge {
    JMRegisterJS *regis = [[JMRegisterJS alloc] init];
    [regis registerJSBridgeBeforeIOSSeven:self WebView:self.baseWebView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)backClicked:(UIButton *)button{
    if (isTeamBuy) {
        PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
        orderVC.index = 100;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}





//- (void)loadRequestWithCookie:(NSString *)urlString {
//
//    // 在此处获取返回的cookie
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];破
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        [cookieDic setObject:cookie.value forKey:cookie.name];
//    }
//
//    // cookie重复，先放到字典进行去重，再进行拼接
//    for (NSString *key in cookieDic) {
//        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
//        [cookieValue appendString:appendString];
//    }
//    NSLog(@"webview cookie=%@", cookieDic);
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
//
//    [super.baseWebView loadRequest:request];
//}

//#pragma mark ---- 旧版本的分享
//- (void)shareForPlatform:(NSDictionary *)data{
//
//    NSNumber *activeid = data[@"active_id"];
//    NSString *platform = data[@"share_to"];
//    if ([activeid integerValue] == 0) {
////        activeid = @([_itemID integerValue]);
//    }
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
//    shareType = data[@"share_to"];
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
//        shareTitle = [responseObject objectForKey:@"share_desc"];
//        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"picture"]];
//        newshareImage = [UIImage imagewithURLString:[imageurl imageShareCompression]];
//        _content = [responseObject objectForKey:@"share_desc"];
//        _shareImage = [UIImage imagewithURLString:[[responseObject objectForKey:@"share_icon"] imageShareCompression]];
//        NSString *sharelink = [responseObject objectForKey:@"share_link"];
//        if ([platform isEqualToString:@""]) {
//            self.activityId = [responseObject objectForKey:@"id"];
//            [self resolveActivityShareParam:responseObject];
//            [self universeShare:data];
//        }else if ([platform isEqualToString:@"wx"]) {
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
//            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharelink;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//        }else if ([platform isEqualToString:@"qq"]) {
//            [UMSocialData defaultData].extConfig.qqData.url = sharelink;
//            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//        }else if ([platform isEqualToString:@"sinawb"]){
//            NSString *sina_content = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
//            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_shareImage)];
//        } else if ([platform isEqualToString:@"web"]){
//            UIPasteboard *pab = [UIPasteboard generalPasteboard];
//            if ([NSString isStringEmpty:sharelink]) {
//                [MBProgressHUD showMessage:@"复制失败"];
//            }else {
//                [pab setString:sharelink];
//                if (pab == nil) {
//                    [MBProgressHUD showMessage:@"请重新复制"];
//                }else
//                {
//                    [MBProgressHUD showMessage:@"已复制"];
//                }
//            }
//            [MBProgressHUD showLoading:@"正在下载二维码..."];
//            //            [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
//            //            [self createKuaiZhaoImage];
//        } else if ([platform isEqualToString:@"qqspa"]){
//            [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
//            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image: _shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//        } else if ([platform isEqualToString:@"wxapp"]){
//            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
//                NSLog(@"wx");
//                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                }];
//            } else {
//                [MBProgressHUD showLoading:@"正在生成快照..."];
//                //                [self createKuaiZhaoImage];
//            }
//        }  else if ([platform isEqualToString:@"pyq"]){
//
//            NSLog(@"friends");
//
//            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                }];
//            } else{
//
//                [MBProgressHUD showLoading:@"正在生成快照..."];
//                //                  isWXFriends = NO;
//                //                [self createKuaiZhaoImage];
//            }
//
//        } else{}
//    } WithFail:^(NSError *error) {
//
//    } Progress:^(float progress) {
//
//    }];
//}
//- (void)resolveProductShareParam:(NSDictionary *)dic {
//    self.share_model.share_type = [dic objectForKey:@"share_type"];
//    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
//    self.share_model.desc = [dic objectForKey:@"share_desc"]; // 文字详情
//    self.share_model.title = [dic objectForKey:@"share_title"]; //标题
//    self.share_model.share_link = [dic objectForKey:@"link"];
//    self.shareView.model = self.share_model;
//}


@end























