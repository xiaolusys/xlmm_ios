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
#import "AFNetworking.h"
#import "MMClass.h"
#import "Reachability.h"
#import "NewLeftViewController.h"
#import "MMDetailsViewController.h"
#import "MobClick.h"

#define login @"login"

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

@end

@implementation AppDelegate

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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;

    self.isFirst = YES;
   // [MiPushSDK registerMiPush:self type:0 connect:YES];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    __unused NSString *plistPath1 = [paths objectAtIndex:0];
    NSLog(@"%@", plistPath1);
    
   
    NSLog(@"%d", self.isLaunchedByNotification);
    
//    [MobClick setLogEnabled:YES];
    
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //填写AppKey，设置发送策略和填写渠道
    [MobClick startWithAppkey:@"5665541ee0f55aedfc0034f4" reportPolicy:BATCH channelId:nil];
    
    
    
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
    
//    LeftMenuViewController *leftMenu = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
//    // 设置代理
//    
//    
//    leftMenu.pushVCDelegate = root;
    
    NewLeftViewController *leftMenu = [[NewLeftViewController alloc] initWithNibName:@"NewLeftViewController" bundle:nil];
//    leftMenu.push

    leftMenu.pushVCDelegate = root;
    RESideMenu *menuVC = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:leftMenu rightMenuViewController:nil];
    
   // menuVC.backgroundImage = [UIImage imageNamed:@"backImage.jpg"];
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
   
    
    return YES;
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
                  NSLog(@"JSON: %@", responseObject);
                  NSString *user_account = [responseObject objectForKey:@"user_account"];
                  if ([user_account isEqualToString:@""]) {
                      
                  } else {
                      NSLog(@"user_account = %@", user_account);
                      [MiPushSDK setAccount:user_account];
                  }
               
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  
                  
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
    NSLog(@"data = %@", data);
    
    // 长连接收到的消息。消息格式跟APNs格式一样
    // 返回数据
    NSString *target_url = nil;
    target_url = [data objectForKey:@"target_url"];
    
    
   
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

    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"分享结果"];
        NSString *strMsg;
        if (resp.errCode == 0) {
            strMsg = @"分享成功";
        } else {
            strMsg = @"分享失败";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else if([resp isKindOfClass:[PayResp class]]){


    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            self.wxCode = code;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:code forKey:@"wxCode"];
            [userDefaults synchronize];
//            NSDictionary *dic = @{@"code":code};
//            NSLog(@"dic11111 = %@", dic);
            
        }else {
            NSLog(@"取消登录");
            NSLog(@"88888888888");
            return;
        }
        //获取token和openid；
        [self getAccess_token];
    } //启动微信支付的response
    
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
                
                //
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
                NSNotification * broadcastMessage = [ NSNotification notificationWithName: @"login" object:self];
                NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                [notificationCenter postNotification: broadcastMessage];

            //    NSLog(@"登录成功");
                
//                传递参数：
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

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_isFirst == YES && self.isLaunchedByNotification == YES) {
        _isFirst = NO;
        
        
        dispatch_after(1.0f, dispatch_get_main_queue(), ^(void){ // 2
           [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":[self.pushInfo objectForKey:@"target_url"]}];
        });
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
                   NSLog(@"url = %@", url);
                   NSLog(@"取消支付或支付失败");
                   //[[NSNotificationCenter defaultCenter] postNotificationName:@"CancleZhifu" object:nil];
                   NSLog(@"AppDelegate ... Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
               }
           }];
//    return [UMSocialSnsService handleOpenURL:url];
    return [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];;

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
