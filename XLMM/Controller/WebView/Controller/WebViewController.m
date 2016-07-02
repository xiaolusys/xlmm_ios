//
//  HuodongViewController.m
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "WebViewController.h"
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
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "CartViewController.h"
#import "JMShareViewController.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "MJExtension.h"
#import "JMShareModel.h"

#import "IMYWebView.h"
#import "Webkit/WKScriptMessage.h"
#import "IosJsBridge.h"


#define USERAGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E238"

//static BOOL isLogin;

@interface WebViewController ()<UIWebViewDelegate,UMSocialUIDelegate,JMShareViewDelegate,WKScriptMessageHandler>

@property (nonatomic, strong)WebViewJavascriptBridge* bridge;

//分享参数
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *des;
@property (nonatomic, strong)UIImage *shareImage;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, strong) UIWebView *shareWebView;
@property (nonatomic, strong) UIWebView *erweimaShareWebView;
//遮罩层
@property (nonatomic, strong) UIView *shareBackView;
//分享页面
@property (nonatomic, strong) YoumengShare *youmengShare;
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
}
- (YoumengShare *)youmengShare {
    if (!_youmengShare) {
        _youmengShare = [[YoumengShare alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _youmengShare;
}

//- (WebViewJavascriptBridge *)bridge {
//
//    return _bridge;
//}
- (void)setWebDiction:(NSMutableDictionary *)webDiction {
    _webDiction = webDiction;
}
- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}

- (BOOL)isShowNavBar {
    _isShowNavBar = false;
    return _isShowNavBar;
}
- (BOOL)isShowRightShareBtn {
    _isShowRightShareBtn = false;
    return _isShowRightShareBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *active = _webDiction[@"type_title"];

    if ([active isEqualToString:@"myInvite"] || [active isEqualToString:@"active"] || _isShowNavBar) {
        self.navigationController.navigationBarHidden = NO;
    }else {
        self.navigationController.navigationBarHidden = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"小鹿努力加载中....."];
    
    NSString *titleName = self.titleName;
    
    [self createNavigationBarWithTitle:titleName selecotr:@selector(backClicked:)];
    
    IMYWebView *baseWebView1 = [[IMYWebView alloc] initWithFrame:self.view.bounds usingUIWebView:NO];
    super.baseWebView = baseWebView1;
    [self.view addSubview:super.baseWebView];
//    super.baseWebView.backgroundColor = [UIColor whiteColor];
//    super.baseWebView.tag = 111;
//    self.baseWebView.delegate = self;
//    super.baseWebView.scalesPageToFit = YES;
//    super.baseWebView.userInteractionEnabled = YES;
    super.baseWebView.viewController = self;
    
    if(super.baseWebView.usingUIWebView)
    {
        NSLog(@"7.0 UIWebView");
        [self registerJsBridge];
    }
    else
    {
        NSLog(@"bigger than8.0 WKWebView");
    }
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    statusBarView.hidden = YES;
    
    NSString *loadStr = nil;
    NSString *active = _webDiction[@"type_title"];
    if ([active isEqualToString:@"myInvite"]) {
        super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
        self.activityId = _webDiction[@"activity_id"];
        loadStr = _webDiction[@"web_url"];
        [self loadData];
    }else if ([active isEqualToString:@"active"]){
        super.baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
        self.activityId = _webDiction[@"activity_id"];//[self.diction objectForKey:@"id"];
        loadStr = _webDiction[@"web_url"];//[self.diction objectForKey:@"act_link"];
        [self loadData];
    }else {
        statusBarView.hidden = NO;
        super.baseWebView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20);
        loadStr = _webDiction[@"web_url"];
    }
    NSURL *url = [NSURL URLWithString:loadStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"webview url=%@ NSURLRequest=%@", url, request);
    [super.baseWebView loadRequest:request];
    
    if(_isShowRightShareBtn){
        [self createTabBarButton];
    }
    
//    self.shareWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    self.shareWebView.hidden = YES;
//    self.shareWebView.tag = 102;
//    [self.view addSubview:self.shareWebView];
    [self.view bringSubviewToFront:super.baseWebView];
    
    _shareImage = [UIImage imageNamed:@"icon-xiaolu.png"];
    _content = @"小鹿美美";

}

- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, self.activityId];
    NSLog(@"Shareview _urlStr=%@ self.activityId=%@", string, self.activityId);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        
        [self resolveActivityShareParam:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


- (void)resolveActivityShareParam:(NSDictionary *)dic {
    //    NSDictionary *dic = _model.mj_keyValues;
    NSLog(@"Share para=%@",dic);
    
    self.share_model.share_type = [dic objectForKey:@"share_type"];

    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.share_model.desc = [dic objectForKey:@"active_dec"]; // 文字详情

    self.share_model.title = [dic objectForKey:@"title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"share_link"];

}

- (void)resolveProductShareParam:(NSDictionary *)dic {
    NSLog(@"Product Share para=%@",dic);
    
    self.share_model.share_type = [dic objectForKey:@"share_type"];
    
    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.share_model.desc = [dic objectForKey:@"share_desc"]; // 文字详情
    
    self.share_model.title = [dic objectForKey:@"share_title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"link"];
    
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
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    self.shareView = shareView;
    _shareDic = nil;

    self.shareView.model = self.share_model;

    JMShareView *cover = [JMShareView show];
    cover.delegate = self;
    //弹出视图
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
    menu.contentView = self.shareView.view;
}

- (void) universeShare:(NSDictionary *)data {
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    self.shareView = shareView;

    if([_webDiction[@"type_title"] isEqualToString:@"ProductDetail"]){
        [self resolveProductShareParam:data];
    }
    self.shareView.model = self.share_model;
    
    JMShareView *cover = [JMShareView show];
    cover.delegate = self;
    //弹出视图
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
    menu.contentView = self.shareView.view;
}
#pragma mark --- 点击隐藏弹出视图
- (void)coverDidClickCover:(JMShareView *)cover {
    //隐藏pop菜单
    [JMPopView hide];
    [SVProgressHUD dismiss];
}


#pragma mark -- UIWebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"完成加载 %ld",(long)webView.tag);
    [SVProgressHUD dismiss];

    if (webView.tag != 102) {
        [self updateUserAgent];
//        [self registerJsBridge];
        return;
    }
    if (webView.isLoading) {
        return;
    }
    
    _webViewImage = [UIImage imagewithWebView:self.shareWebView];

    [SVProgressHUD dismiss];
    
    if (!self.isWXFriends) {
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:_webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
//        [self cancleShareBtnClick:nil];
    } else {
//        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:self.kuaiZhaoImage socialUIDelegate:self];
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
//        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:_webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
//        [self cancleShareBtnClick:nil];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"webview didFailLoadWithError error=%@", error);
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}

- (void)updateUserAgent{
    NSString *oldAgent = [super.baseWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if(oldAgent == nil) return;
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSLog(@"oldAgent=%@",oldAgent);
    if(oldAgent != nil) {
        
        NSRange range = [oldAgent rangeOfString:[NSString stringWithFormat:@"%@%@", @"xlmm/", app_Version]];
        if(range.length > 0)
        {
            return;
        }
        
    }
    
    NSString *newAgent = [oldAgent stringByAppendingString:@"; xlmm/"];
    newAgent = [NSString stringWithFormat:@"%@%@; uuid/%@",newAgent, app_Version, [IosJsBridge getMobileSNCode]];
    
    //判断老版本1.8.4及以前使用useragent是xlmm；需要去除掉
    NSRange newrange = [newAgent rangeOfString:@"xlmm;"];
    if(newrange.length > 0)
    {
        newAgent = [newAgent stringByReplacingOccurrencesOfString:@"; xlmm;" withString:@""];
    }
    
    NSLog(@"newAgent=%@",newAgent);
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
}


#pragma mark - 注册js bridge供h5页面调用
- (void)registerJsBridge {
    if (_bridge) {
        NSLog(@"Already reg!");
        return ;
    }
    NSLog(@"registerJsBridge!");
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.baseWebView.realWebView];

    [self.bridge setWebViewDelegate:self];
    
    [self.bridge registerHandler:@"jumpToNativeLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self jsLetiOSWithData:data callBack:responseCallback];
    }];
    /**
     *   统一的分享接口，注意这个jsbridge实现逻辑错误，需要重新按照接口文档的参数来重写此函数。
     */
    [self.bridge registerHandler:@"callNativeUniShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeUniShareFunc");
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            [self universeShare:data];
        }
    }];
    /**
     *   进入购物车  -- 判断是否登录
     */
    [self.bridge registerHandler:@"jumpToNativeLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            [self jsLetiOSWithData:data callBack:responseCallback];
        }
    }];
    
    [self.bridge registerHandler:@"getNativeMobileSNCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *device = [IosJsBridge getMobileSNCode];
        responseCallback(device);
    }];
    /**
     *  返回按钮
     */
    [self.bridge registerHandler:@"callNativeBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    /**
     *  老的分享接口，带活动id
     */
    [self.bridge registerHandler:@"callNativeShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"callNativeShareFunc");
        [self shareForPlatform:data];
    }];
    /**
     *  详情界面加载
     */
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {

        BOOL isLoading = data[@"isLoading"];
        if (!isLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}



/**
 *  跳转购物车
 */
- (void)jsLetiOSWithData:(id )data callBack:(WVJBResponseCallback)block {
    NSString *target_url = [data objectForKey:@"target_url"];
    [JumpUtils jumpToLocation:target_url viewController:self];
}


#pragma mark 解析targeturl 跳转到不同的界面
- (void)jumpToJsLocation:(NSDictionary *)dic{
    
    NSString *target_url = [dic objectForKey:@"target_url"];
    
    if (target_url == nil) {
        return;
    }
    [JumpUtils jumpToLocation:target_url viewController:self];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的专属二维码已保存，可用微信群发200好友哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        _webViewImage = nil;
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
#pragma mark ---- 旧版本的分享
- (void)shareForPlatform:(NSDictionary *)data{

    NSNumber *activeid = data[@"active_id"];
    NSString *platform = data[@"share_to"];
    if ([activeid integerValue] == 0) {
//        activeid = @([_itemID integerValue]);
    }
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
    shareType = data[@"share_to"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        shareTitle = [responseObject objectForKey:@"share_desc"];
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"picture"]];
        newshareImage = [UIImage imagewithURLString:[imageurl imageShareCompression]];
        _content = [responseObject objectForKey:@"share_desc"];
        _shareImage = [UIImage imagewithURLString:[[responseObject objectForKey:@"share_icon"] imageShareCompression]];
        NSString *sharelink = [responseObject objectForKey:@"share_link"];
        if ([platform isEqualToString:@""]) {
            self.activityId = [responseObject objectForKey:@"id"];
            [self resolveActivityShareParam:responseObject];
            [self universeShare:data];
        }else if ([platform isEqualToString:@"wx"]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharelink;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
        }else if ([platform isEqualToString:@"qq"]) {
            [UMSocialData defaultData].extConfig.qqData.url = sharelink;
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
        }else if ([platform isEqualToString:@"sinawb"]){
            NSString *sina_content = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_shareImage)];
        } else if ([platform isEqualToString:@"web"]){
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
            //            [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
//            [self createKuaiZhaoImage];
        } else if ([platform isEqualToString:@"qqspa"]){
            [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image: _shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
        } else if ([platform isEqualToString:@"wxapp"]){
            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                NSLog(@"wx");
                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                }];
            } else {
                [SVProgressHUD showWithStatus:@"正在生成快照..."];
//                [self createKuaiZhaoImage];
            }
        }  else if ([platform isEqualToString:@"pyq"]){

            NSLog(@"friends");

            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                }];
            } else{

                [SVProgressHUD showWithStatus:@"正在生成快照..."];
                //                  isWXFriends = NO;
//                [self createKuaiZhaoImage];
            }

        } else{}
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
}
- (void)dealloc {
    self.shareWebView = nil;
    self.webViewImage = nil;
    self.baseWebView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.shareWebView = nil;
    self.webViewImage = nil;
    self.baseWebView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD dismiss];
}

- (void)hiddenNavigationView{
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark ----- 分享调用 -- 调用原生的分享这里就不需要了
//- (void)shareForPlatform:(NSDictionary *)data{
//    
//    NSNumber *activeid = data[@"active_id"];
//    NSString *platform = data[@"share_to"];
//    //    NSString *platform = @"web";
//    
//    if ([activeid integerValue] == 0) {
//        //        self.activityId = activeid;
//        activeid = @([_itemID integerValue]);
//    }
//    
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
//    
//    shareType = data[@"share_to"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        shareTitle = [responseObject objectForKey:@"share_desc"];
//        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"picture"]];
//        
//        newshareImage = [UIImage imagewithURLString:imageurl];
//        _content = [responseObject objectForKey:@"share_desc"];
//        _shareImage = [UIImage imagewithURLString:[responseObject objectForKey:@"share_icon"]];
//        NSString *sharelink = [responseObject objectForKey:@"share_link"];
//        
//        if ([platform isEqualToString:@"wx"]) {
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
//            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharelink;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//            
//        }else if ([platform isEqualToString:@"qq"]) {
//            NSLog(@"qq");
//            
//            [UMSocialData defaultData].extConfig.qqData.url = sharelink;
//            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//            
//            
//        }else if ([platform isEqualToString:@"sinawb"]){
//            NSLog(@"wb");
//            NSString *sina_content = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
//            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_shareImage)];
//            
//        } else if ([platform isEqualToString:@"web"]){
//            NSLog(@"copy");
//            UIPasteboard *pab = [UIPasteboard generalPasteboard];
//            NSString *str = sharelink;
//            if (str == nil) {
//                [SVProgressHUD showSuccessWithStatus:@"复制失败"];
//                return ;
//            }
//            [pab setString:str];
//            if (pab == nil) {
//                [SVProgressHUD showErrorWithStatus:@"请重新复制"];
//            }else
//            {
//                [SVProgressHUD showSuccessWithStatus:@"已复制"];
//            }
//            
//            [SVProgressHUD showWithStatus:@"正在下载二维码..."];
//            //            [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
//            [self createKuaiZhaoImage];
//        } else if ([platform isEqualToString:@"qqspa"]){
//            NSLog(@"zone");
//            
//            [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
//            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//            
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image: _shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//        } else if ([platform isEqualToString:@"wxapp"]){
//            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
//                NSLog(@"wx");
//                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
//                
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                    
//                }];
//                
//            } else {
//                [SVProgressHUD showWithStatus:@"正在生成快照..."];
//                //                [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];
//                [self createKuaiZhaoImage];
//            }
//            
//        }  else if ([platform isEqualToString:@"pyq"]){
//            
//            NSLog(@"friends");
//            
//            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//                
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                    
//                }];
//            } else{
//                
//                [SVProgressHUD showWithStatus:@"正在生成快照..."];
//                //                  isWXFriends = NO;
//                //                [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];
//                [self createKuaiZhaoImage];
//            }
//            
//        } else{
//            
//            NSLog(@"others");
//        }
//    }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
//         }];
//}
//- (void)dealloc{
//    self.shareWebView =nil;
//    webViewImage = nil;
////    self.webView = nil;
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//}


//
//        if ([shareType isEqualToString:@"pyq"] || (self.isPic && self.isWeixinFriends)) {
//            [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//            self.isWeixinFriends = NO;
//        } else if ([shareType isEqualToString:@"wxapp"] || (self.isPic && self.isWeixin)) {
//            [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:webViewImage socialUIDelegate:self];
//            //        [UMSocialData defaultData].extConfig.wxMessageType = 0;
//            [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//
//            self.isWeixin = NO;
//        } else if ([shareType isEqualToString:@"web"] || self.isCopy){
//            // 保存本地二维码
//            UIImageWriteToSavedPhotosAlbum(webViewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//            self.isCopy = NO;
//        }
//
@end























