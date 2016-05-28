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

#define kService [NSBundle mainBundle].bundleIdentifier
#define kAccount @"so.xiaolu.m.xiaolumeimei"
#define USERAGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E238"

//static BOOL isLogin;

@interface WebViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong)WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;

@property (nonatomic ,strong) UIWebView *baseWebView;

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

@property (nonatomic, strong)NSNumber *activityId;



@property (nonatomic, strong)NSDictionary *nativeShare;

/**
 *  分享数据字典
 */
@property (nonatomic, strong) NSDictionary *shareDic;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString *itemID;
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([_active isEqualToString:@"myInvite"]) {
        self.navigationController.navigationBarHidden = NO;
    }else if ([_active isEqualToString:@"active"]){
        self.navigationController.navigationBarHidden = NO;
    }else {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)tiaozhuan:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *ID = [userInfo objectForKey:@"productID"];
    
    MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:ID isChild:NO];
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
- (void)setEventLink:(NSString *)eventLink {
    _eventLink = eventLink;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD showWithStatus:@"小鹿努力加载中....."];
    
    NSString *titleName = self.titleName;
    
    [self createNavigationBarWithTitle:titleName selecotr:@selector(backClicked:)];
    
    UIWebView *baseWebView = [[UIWebView alloc] init];
    self.baseWebView = baseWebView;
    [self.view addSubview:self.baseWebView];
    self.baseWebView.backgroundColor = [UIColor whiteColor];
    self.baseWebView.tag = 111;
    self.baseWebView.delegate = self;
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.userInteractionEnabled = YES;
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    statusBarView.hidden = YES;
    
    NSString *loadStr = nil;
    if ([_active isEqualToString:@"myInvite"]) {
        baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
        loadStr = self.eventLink;
    }else if ([_active isEqualToString:@"active"]){
        baseWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
        self.activityId = [self.diction objectForKey:@"id"];
        loadStr = [self.diction objectForKey:@"act_link"];
    }else {
        statusBarView.hidden = NO;
        baseWebView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20);
        self.itemID = self.goodsID;
        loadStr = _eventLink;
    }
    NSURL *url = [NSURL URLWithString:loadStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.baseWebView loadRequest:request];

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareIconImage2.png"]];
    imageView1.frame = CGRectMake(25, 13, 20, 20);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    button1.hidden = YES;

    self.shareWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.shareWebView.hidden = YES;
    [self.view addSubview:self.shareWebView];
    [self.view bringSubviewToFront:self.baseWebView];
    
    _shareImage = [UIImage imageNamed:@"icon-xiaolu.png"];
    _content = @"小鹿美美";

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

    _shareDic = nil;
    if ([_active isEqualToString:@"active"] || [_active isEqualToString:@"myInvite"]) {
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
    }else {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        
        [self createSharData];
        
    }
    
}

- (void)setDiction:(NSDictionary *)diction {
    
    _diction = diction;
}

#pragma mark ---- 创建分享数据
- (void)createSharData {
    if (_shareDic == nil) {
        //网络请求
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/share/product?product_id=%@",Root_URL,_itemID];
        
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        [manage GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _shareDic = responseObject;
            
            
            [self addShareView:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"error-------%@", error);
        }];
        
    }
}

#pragma mark ---- 分享视图，包括分享按钮的点击
//分享视图增加
- (void)addShareView:(NSDictionary *)dicShare {
    [SVProgressHUD dismiss];
    
    if ([_active isEqualToString:@"active"] || [_active isEqualToString:@"myInvite"]) {
        NSString *type = dicShare[@"share_type"];
        if ([type isEqualToString:@"link"]) {
            self.isPic = NO;
        }else {
            self.isPic = YES;
        }
        self.imageUrlString = [dicShare objectForKey:@"share_icon"]; //图片
        self.content = [dicShare objectForKey:@"active_dec"]; // 文字详情
    }else {
        self.content = [dicShare objectForKey:@"desc"]; //分享的文字详情
        self.imageUrlString = dicShare[@"share_img"];   //图片
        self.urlResource = dicShare[@"desc"]; //分享的链接等
    }
    self.titleStr = [dicShare objectForKey:@"title"]; //标题
    self.url = [dicShare objectForKey:@"share_link"];
    self.kuaizhaoLink = [dicShare objectForKey:@"share_link"];

    self.imageData = [UIImage imagewithURLString:_imageUrlString];
    self.kuaiZhaoImage = [UIImage imagewithURLString:_kuaizhaoLink];
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
    
    if ([WXApi isWXAppInstalled]) {
        self.youmengShare.snapshotBtn.hidden = NO;
        self.youmengShare.friendsSnaoshotBtn.hidden = NO;
    }
    
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
    self.youmengShare.snapshotBtn.hidden = YES;
    self.youmengShare.friendsSnaoshotBtn.hidden = YES;
}
//提示分享失败
- (void)createPrompt {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不好，分享失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

/**
 *  取消按钮的点击
 */
- (void)cancleShareBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self.shareBackView removeFromSuperview];
    }];
}
/**
 *  微信分享的点击
 */
- (void)weixinShareBtnClick:(UIButton *)btn{
    if (self.url == nil) {
        [self createPrompt];
        return;
    }
    
    if (self.isPic) {
        
        //图片
        self.isWeixin = YES;
        
        [self cancleShareBtnClick:nil];
    }else {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            [self hiddenNavigationView];
        }];
        
        [self cancleShareBtnClick:nil];
    }
    
}
/**
 *  朋友圈分享的点击
 */
- (void)friendsShareBtnClick:(UIButton *)btn {
    if (self.url == nil) {
        [self createPrompt];
        return;
    }
    if (self.isPic) {
        //图片
        self.isWeixinFriends = YES;
//        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
        [self createKuaiZhaoImage];
        //        [self createKuaiZhaoImage];
        [self cancleShareBtnClick:nil];
    }else {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
        [UMSocialData defaultData].extConfig.wxMessageType = 0;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        [self cancleShareBtnClick:nil];
    }
}
/**
 *  QQ分享的点击
 */
- (void)qqshareBtnClick:(UIButton *)btn {
    if (self.url == nil) {
        [self createPrompt];
        return;
    }
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    }];
    
    [self cancleShareBtnClick:nil];
}
/**
 *  QQ空间分享的点击
 */
- (void)qqspaceShareBtnClick:(UIButton *)btn {
    if (self.url == nil) {
        [self createPrompt];
        return;
    }
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image:self.imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
    }];
    [self cancleShareBtnClick:nil];
}
/**
 *  微博分享的点击
 */
- (void)weiboShareBtnClick:(UIButton *)btn {
    if (self.url == nil) {
        [self createPrompt];
        return;
    }
    NSString *sina_content = [NSString stringWithFormat:@"%@%@",self.titleStr, self.url];
    [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(self.imageData)];
    [self cancleShareBtnClick:nil];
}
/**
 *  复制的点击
 */
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
    //    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
    
    [self cancleShareBtnClick:nil];
}
///**
// *  微信快照
// */
//- (void)snapshotBtnClick:(UIButton *)btn {
////    self.shareWebView.hidden = NO;
//    [SVProgressHUD showWithStatus:@"正在生成快照..."];
//    self.isWXFriends = NO;
//    [self createKuaiZhaoImage];
//    
//}
///**
// *  朋友圈快照
// */
//- (void)friendsSnaoshotBtnClick:(UIButton *)btn{
////    self.shareWebView.hidden = NO;
//    [SVProgressHUD showWithStatus:@"正在生成快照..."];
//    self.isWXFriends = YES;
//    [self createKuaiZhaoImage];
//    
//}
- (void)createKuaiZhaoImage {
    [self.view bringSubviewToFront:self.shareWebView];
    _webViewImage = nil;
    NSURL *url = [NSURL URLWithString:self.kuaizhaoLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.shareWebView loadRequest:request];
    self.shareWebView.delegate = self;
    self.shareWebView.scalesPageToFit = YES;
    self.shareWebView.tag = 102;
//    _webViewImage = [UIImage imagewithWebView:self.shareWebView];

}


#pragma mark -- UIWebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"完成加载");
    [SVProgressHUD dismiss];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];

    if (webView.tag != 102) {
        [self updateUserAgent];
        [self registerJsBridge];
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
        [self cancleShareBtnClick:nil];
    } else {
//        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:self.kuaiZhaoImage socialUIDelegate:self];
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
//        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:_webViewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        [self cancleShareBtnClick:nil];
    }

}

- (void)updateUserAgent{
    NSString *oldAgent = [self.baseWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if(oldAgent == nil) return;
    
    if(oldAgent != nil) {
        
        NSRange range = [oldAgent rangeOfString:@"xlmm;"];
        if(range.length > 0)
        {
            return;
        }
        
    }
    NSString *newAgent = [oldAgent stringByAppendingString:@"; xlmm;"];

    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//
//}

#pragma mark - 注册js bridge供h5页面调用
- (void)registerJsBridge {
    if (_bridge) {
        return ;
    }
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.baseWebView];
    
    [self.bridge registerHandler:@"jumpToNativeLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self jsLetiOSWithData:data callBack:responseCallback];
    }];
    /**
     *   分享
     */
    [self.bridge registerHandler:@"callNativeUniShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            [self rightBarButtonAction];
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
        NSString *device = [self getMobileSNCode];
        responseCallback(device);
    }];
    /**
     *  返回按钮
     */
    [self.bridge registerHandler:@"callNativeBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    /**
     *  小鹿妈妈 --- 我的邀请
     */
    [self.bridge registerHandler:@"callNativeShareFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self shareForPlatform:data];
        
    }];
    
    /**
     *  详情界面加载
     */
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {

        BOOL isLoading = data[@"isLoading"];
//        isLoading = !isLoading;
        if (!isLoading) {
            [SVProgressHUD dismiss];
        }
    }];
    
}




- (void)jsLetiOSWithData:(id )data callBack:(WVJBResponseCallback)block {
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    NSString *target_url = [data objectForKey:@"target_url"];
    
    if (target_url == nil) {
        return;
    }
    
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/shopping_cart"]) {
        
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
            [self.navigationController pushViewController:cartVC animated:YES];
        }
    }
}
- (void)dealloc {
    self.shareWebView = nil;
    self.webViewImage = nil;
    self.baseWebView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}
- (void)hiddenNavigationView{
    self.navigationController.navigationBarHidden = YES;
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
    //    NSString *platform = @"web";
    
    if ([activeid integerValue] == 0) {
        //        self.activityId = activeid;
        activeid = @([_itemID integerValue]);
    }
    
    
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];

    shareType = data[@"share_to"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        shareTitle = [responseObject objectForKey:@"share_desc"];
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"picture"]];

        newshareImage = [UIImage imagewithURLString:imageurl];
        _content = [responseObject objectForKey:@"share_desc"];
        _shareImage = [UIImage imagewithURLString:[responseObject objectForKey:@"share_icon"]];
        NSString *sharelink = [responseObject objectForKey:@"share_link"];

        if ([platform isEqualToString:@""]) {
            self.activityId = [responseObject objectForKey:@"id"];
            [self rightBarButtonAction];
            
        }else if ([platform isEqualToString:@"wx"]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharelink;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];

        }else if ([platform isEqualToString:@"qq"]) {
            NSLog(@"qq");

            [UMSocialData defaultData].extConfig.qqData.url = sharelink;
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];


        }else if ([platform isEqualToString:@"sinawb"]){
            NSLog(@"wb");
            NSString *sina_content = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_shareImage)];

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
            //            [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
            [self createKuaiZhaoImage];
        } else if ([platform isEqualToString:@"qqspa"]){
            NSLog(@"zone");

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
                //                [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];
                [self createKuaiZhaoImage];
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
                //                [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"share_link"]];
                [self createKuaiZhaoImage];
            }

        } else{

            NSLog(@"others");
        }
        
    }
     
     
     
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
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























