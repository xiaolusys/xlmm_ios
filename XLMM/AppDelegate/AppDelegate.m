//
//  AppDelegate.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//
#import "MiPushSDK.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "Pingpp.h"
#import "MMRootViewController.h"
#import "MMClass.h"
#import "Reachability.h"
#import "NewLeftViewController.h"
#import "MMDetailsViewController.h"
#import "ActivityView.h"
#import "IMYWebView.h"
#import "IosJsBridge.h"

#define login @"login"
#import "JMFirstOpen.h"
#define appleID @"so.xiaolu.m.xiaolumeimei"

@interface AppDelegate ()<UIAlertViewDelegate, MiPushSDKDelegate>

@property (nonatomic ,copy) NSString *wxCode;
@property (nonatomic ,copy) NSString *access_token;
@property (nonatomic ,copy) NSString *openid;
@property (nonatomic, strong) NSDictionary *tokenInfo;
@property (nonatomic, strong) NSDictionary *userInfo;


@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *miRegid;
@property (nonatomic, copy) NSDictionary *pushInfo;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong)ActivityView *startV;
@property (nonatomic, strong)NSTimer *sttime;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)NSString *imageUrl;
/**
 *  判断是否为支付页面跳转过来的
 */
//@property (nonatomic,assign) BOOL isApinPayGo;

@end

@implementation AppDelegate{
    
}

- (NSString *)stringFromStatus:(NetworkStatus)status{
    NSString *string;
    switch (status) {
        case NotReachable:
            string = @"无网络连接，请检查您的网络";
            break;
        case ReachableViaWiFi:
            string = @"wifi";
            break;
        case ReachableViaWWAN:
            string = @"wwan";
            break;
            
        default:
            
            string = @"unknown";
            break;
    }
    return string;
}

- (void)ActivityTimeUpdate {
    self.timeCount++;
    if (self.timeCount > 2) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
        
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.isApinPayGo = YES;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [NSThread sleepForTimeInterval:2.0];
    
    [self getServerIP];
    [self updateLoginState];
    
    self.startV = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.startV];
    self.sttime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ActivityTimeUpdate) userInfo:nil repeats:YES];
    
    NSString *activityUrl = [NSString stringWithFormat:@"%@/rest/v1/activitys/startup_diagrams", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:activityUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        if (responseObject[@"picture"] == nil)return;
        [self startDeal:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger count = [userDefaults integerForKey:@"StartCount"];
    
    NSLog(@"count = %ld", (long)count);
    
    count++;
    
    [userDefaults setInteger:count forKey:@"StartCount"];
    [userDefaults synchronize];
    if (count == 22) {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"去评价" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        //        [alertView show];
        
    }
    /**
     *  检测是否是第一次打开  -- 并且记录打开的次数
     */
    [JMFirstOpen recoderAppLoadNum];
    
    self.isFirst = YES;
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    __unused NSString *plistPath1 = [paths objectAtIndex:0];
    NSLog(@"%@", plistPath1);
    
    
    NSLog(@"%d", self.isLaunchedByNotification);
    
    //[MobClick setLogEnabled:YES];
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = @"5665541ee0f55aedfc0034f4";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //    Class cls = NSClassFromString(@"UMANUtil");
    //    SEL deviceIDSelector = @selector(openUDIDString);
    //    NSString *deviceID = nil;
    //    if(cls && [cls respondsToSelector:deviceIDSelector]){
    //        deviceID = [cls performSelector:deviceIDSelector];
    //    }
    //    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:nil];
    //
    //    NSLog(@"－－－－－－－－－－－－%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    
    [UMSocialData setAppKey:@"5665541ee0f55aedfc0034f4"];
    //qq分享
    [UMSocialQQHandler setQQWithAppId:@"1105009062" appKey:@"V5H2L8ij9BNx6qQw" url:@"http://www.umeng.com/social"];
    
    //微信分享
    [UMSocialWechatHandler setWXAppId:@"3c7b4e3eb5ae4cfb132b2ac060a872ee" appSecret:@"wx25fcb32689872499" url:@"http://www.umeng.com/social"];
    
    //微博分享
    [WeiboSDK registerApp:@"2475629754"];
    
    
    
    [WXApi registerApp:@"wx25fcb32689872499" withDescription:@"weixin"];
    
    //创建导航控制器，添加根视图控制器
    MMRootViewController *root = [[MMRootViewController alloc] initWithNibName:@"MMRootViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];

    NewLeftViewController *leftMenu = [[NewLeftViewController alloc] initWithNibName:@"NewLeftViewController" bundle:nil];
    
    leftMenu.pushVCDelegate = root;
    RESideMenu *menuVC = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:leftMenu rightMenuViewController:nil];
    menuVC.view.backgroundColor = [UIColor settingBackgroundColor];
    menuVC.menuPreferredStatusBarStyle = 1;
    menuVC.delegate = self;
    menuVC.contentViewShadowColor = [UIColor blackColor];
    menuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    menuVC.contentViewShadowOpacity = 0.6;
    menuVC.contentViewShadowRadius = 12;
    menuVC.contentViewShadowEnabled = YES;
    
    
    self.window.rootViewController = menuVC;
    
    
    [self.window makeKeyAndVisible];
    
    
    if (launchOptions != nil) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification != nil) {
            self.pushInfo = remoteNotification;
            self.isLaunchedByNotification = YES;
        }
    }
    // -- 添加UserAgent
    [self createUserAgent];
    return YES;
}


- (void)startDeal:(NSDictionary *)dic {
    self.imageUrl = [dic objectForKey:@"picture"];
    NSLog(@"startDeal imageUrl %@", self.imageUrl);
    if (self.imageUrl.length == 0 || [self.imageUrl class] == [NSNull class]) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
    }
    self.startV.imageV.alpha = 1;
    
    [self.startV.imageV sd_setImageWithURL:[NSURL URLWithString:[self.imageUrl imagePostersCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.3 animations:^{
            self.startV.imageV.alpha = 0;
        }];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //  https://itunes.apple.com/us/app/xiao-lu-mei-mei/id1051166985
    if (buttonIndex == 1) {
        NSString * str = @"https://itunes.apple.com/us/app/xiao-lu-mei-mei/id1051166985";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:0 forKey:@"StartCount"];
        [userDefaults synchronize];
        
    }
    
    
    
}

- (void)updateLoginState{
    //get /customer/user_profile to check has logined
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // http://m.xiaolu.so/rest/v1/users/profile
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        NSDictionary *result = responseObject;
        if (([result objectForKey:@"id"] != nil)  && ([[result objectForKey:@"id"] integerValue] != 0)) {
            // 手机登录成功 ，保存用户信息以及登录途径
            [defaults setBool:YES forKey:kIsLogin];
            NSLog(@"Still logined");
        }
        else{
            // 手机登录需要 ，保存用户信息以及登录途径
            [defaults setBool:NO forKey:kIsLogin];
            NSLog(@"maybe cookie timeout,need login");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 手机登录需要 ，保存用户信息以及登录途径
        [defaults setBool:NO forKey:kIsLogin];
        NSLog(@"maybe cookie timeout,need login");
    }];
    
    
}

- (void)getServerIP{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *serverip = [defaults objectForKey:@"serverip"];
    if((serverip != nil) && (![serverip isEqualToString:@""])){
        Root_URL = serverip;
    }
    
    NSLog(@"serverip %@, Root_url %@",serverip, Root_URL);
}


#pragma mark UIApplicationDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    // 方式1
    
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    
    const char *bytes = pToken.bytes;
    
    NSUInteger iCount = pToken.length;
    
    for (int i = 0; i < iCount; i++) {
        
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
        
    }
    self.deviceToken = deviceTokenString1;
    self.deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [MiPushSDK bindDeviceToken:pToken];
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    // 注册APNS失败。。
    NSLog(@"Regist fail%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //    NSLog(@"UserInfo = %@", userInfo);
    [MiPushSDK handleReceiveRemoteNotification :userInfo];
    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    NSLog(@"messageID = %@", messageId);
    [MiPushSDK openAppNotify:messageId];
}




#pragma mark MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    
    if ([selector isEqualToString:@"registerMiPush:type:connect:"]) {
        
        
    } else if ([selector isEqualToString:@"bindDeviceToken:"]){
        NSLog(@"data = %@", data);
        
        
        self.miRegid = [data objectForKey:@"regid"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
        
        NSLog(@"%@ %@", self.deviceUUID, self.deviceToken);
        NSDictionary *parameters = @{@"platform":@"ios",
                                     @"regid":self.miRegid,
                                     @"device_id":self.deviceUUID,
                                     @"ios_token":self.deviceToken
                                     };
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:parameters forKey:@"MiPush"];
        [defaults synchronize];
        
        NSLog(@"parameters = %@", parameters);
        NSLog(@"urlStr = %@", urlString);
        
        [manager POST:urlString parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //  NSError *error;
                  if (!responseObject) return ;
                  NSLog(@"JSON: %@", responseObject);
                  NSString *user_account = [responseObject objectForKey:@"user_account"];
                  
                  if (![user_account isEqualToString:@""]){
                      [MiPushSDK setAccount:user_account];
                      //保存user_account
                      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                      [user setObject:user_account forKey:@"user_account"];
                      [user synchronize];
                  }
              }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@-------", error);
              }];
        //
        
    }
    
    
    
}



- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    NSLog(@"请求失败");
    // 请求失败
}

- ( void )miPushReceiveNotification:( NSDictionary *)data
{
    NSLog(@"---------------data = %@", data);
    //
    //    // 长连接收到的消息。消息格式跟APNs格式一样
    //    // 返回数据
    NSString *target_url = nil;
    target_url = [data objectForKey:@"target_url"];
    
    if (target_url != nil) {
        if (self.isLaunchedByNotification == YES) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
            return;
        }
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil userInfo:@{@"target_url":target_url}];
            return;
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
        }
        
    }
    
}



#pragma mark --微信回调方法--



-(void)onResp:(BaseResp *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //    SendAuthResp *aresp = (SendAuthResp *)resp;
    //    if (aresp.errCode== 0) {
    //        NSString *code = aresp.code;
    //
    //        self.wxCode = code;
    //
    //
    //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //        [userDefaults setValue:code forKey:@"wxCode"];
    //        [userDefaults synchronize];
    //
    //
    //        NSDictionary *dic = @{@"code":code};
    //        NSLog(@"dic11111 = %@", dic);
    //
    //    }
    //    //获取token和openid；
    //     [self getAccess_token];
    
    //  NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
    //    if([resp isKindOfClass:[SendMessageToWXResp class]])
    //    {
    ////        NSString *strTitle = [NSString stringWithFormat:@"分享结果"];
    ////        NSString *strMsg;
    ////        if (resp.errCode == 0) {
    ////            strMsg = @"分享成功";
    ////        } else {
    ////            strMsg = @"分享失败";
    ////        }
    ////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    ////        [alert show];
    //
    //    } else if([resp isKindOfClass:[PayResp class]]){
    //
    //
    //    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
    //        [SVProgressHUD showInfoWithStatus:@"登录中....."];
    //        SendAuthResp *aresp = (SendAuthResp *)resp;
    //        if (aresp.errCode== 0) {
    //            NSString *code = aresp.code;
    //            self.wxCode = code;
    //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //            [userDefaults setValue:code forKey:@"wxCode"];
    //            [userDefaults synchronize];
    ////            NSDictionary *dic = @{@"code":code};
    ////            NSLog(@"dic11111 = %@", dic);
    //
    //        }else {
    //            NSLog(@"取消登录");
    //            NSLog(@"88888888888");
    //            return;
    //        }
    //        //获取token和openid；
    //        [self getAccess_token];
    //    } //启动微信支付的response
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //[SVProgressHUD showInfoWithStatus:@"登录中....."];
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            self.wxCode = code;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:code forKey:@"wxCode"];
            [userDefaults synchronize];
        }else {
            NSLog(@"取消登录");
            return;
        }
        //获取token和openid；
        [self getAccess_token];
    }
}



-(void)getAccess_token
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx25fcb32689872499",@"3c7b4e3eb5ae4cfb132b2ac060a872ee",self.wxCode];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.tokenInfo = dic;
                
                NSLog(@"dic = %@", dic);
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                
                [self getUserInfo];
                //传入openID and
            }
            
        });
    });
}



-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,self.openid];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dic2 = %@", dic);
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                self.userInfo = dic;
                //                NSLog(@"tokeninfo = %@", self.tokenInfo);
                //                NSLog(@"userInfo = %@", self.userInfo);
                
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:self.userInfo forKey:@"userInfo"];
                [userdefault setBool:YES forKey:kIsLogin];
                [userdefault setObject:kWeiXinLogin forKey:kLoginMethod];
                NSDictionary *wxUserInfo = @{@"nickname":[dic objectForKey:@"nickname"],
                                             @"headimgurl":[dic objectForKey:@"headimgurl"]
                                             };
                [userdefault setObject:wxUserInfo forKey:kWeiXinUserInfo];
                [userdefault synchronize];
                
                //                NSLog(@"name = %@", [dic objectForKey:@"nickname"]);
                //  发送微信登录成功的通知
                
                NSUserDefaults *userdefault0 = [NSUserDefaults standardUserDefaults];
                NSString *author = [userdefault0 objectForKey:kWeiXinauthorize];
                
                if ([author isEqualToString:@"wxlogin"]) {
                    
                    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"login" object:self];
                    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                    [notificationCenter postNotification: broadcastMessage];
                } else if([author isEqualToString:@"binding"]){
                    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"bindingwx" object:self];
                    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                    [notificationCenter postNotification: broadcastMessage];
                }
                
            }
        });
        
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    /**
     *  这里 -- > 如果在进入另一个App后不操作任何事情,点击状态栏中的返回按钮.会调用这个方法,这里使用isApinPayGo判断
     */
//    if (self.isApinPayGo) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isApinPayGo" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isShareApinPayGo" object:nil];
//    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;

    NSLog(@"applicationDidBecomeActive");
    [self updateLoginState];
    
    if (_isFirst == YES && self.isLaunchedByNotification == YES) {
        _isFirst = NO;
        
        if ([self.pushInfo objectForKey:@"target_url"] == nil) {
            
            
        } else {
            dispatch_after(1.0f, dispatch_get_main_queue(), ^(void){ // 2
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":[self.pushInfo objectForKey:@"target_url"]}];
            });
        }
    }
    
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertView *alterView = [[UIAlertView alloc]  initWithTitle:nil message:[self stringFromStatus:status] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alterView show];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];
    //  return [UMSocialSnsService handleOpenURL:url];
}


//   [PayResp code]....



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    NSString *urlString = [url absoluteString];
    
    NSLog(@"----------url = %@", urlString);

    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
                   NSLog(@"支付成功");
                   //  发送支付成功的 通知
                   NSLog(@"url = %@", url);
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhifuSeccessfully" object:nil];
                   
               } else {
                   // 支付失败或取消
                   // 发送支付不成功的 通知
                   
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"CancleZhifu" object:nil];
                   
                                      
               }
           }];
    //    return [UMSocialSnsService handleOpenURL:url];
    return [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];
    
    
    
    
}

#pragma mark ---- User_Agent
//从webview获得浏览器中的useragent，并进行更新
- (void)createUserAgent {
    IMYWebView *webView = [[IMYWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    //add my info to the new agent
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
    
    //regist the new agent
    NSDictionary *userAgent = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent",  nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userAgent];
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    [self presentNotification];
}
-(void)presentNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"下载完成!";
    localNotification.alertAction = @"后台传输下载已完成!";
    //提示音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //icon提示加1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
/**
 *  接收到内存警告时候调用
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
@end
