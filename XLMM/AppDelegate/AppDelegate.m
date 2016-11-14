//
//  AppDelegate.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//
#import "MiPushSDK.h"
#import "AppDelegate.h"
#import "JMStoreManager.h"
//#import "Pingpp.h"
#import "NewLeftViewController.h"
#import "IMYWebView.h"
#import "IosJsBridge.h"
#import "Udesk.h"
#import "JMHomeRootController.h"
#import "JMDevice.h"
#import "UIImage+UIImageExt.h"
#import "JMPayment.h"

#define login @"login"

#define appleID @"so.xiaolu.m.xiaolumeimei"

@interface AppDelegate ()

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

@property (nonatomic, strong)NSTimer *sttime;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)NSString *imageUrl;

@end

@implementation AppDelegate

- (void)udeskInit{
    //uDesk 客服
    [UdeskManager initWithAppkey:@"e7bfd4447bf206d17fb536240a9f4fbb" domianName:@"xiaolumeimei.udesk.cn"];
}
- (void)umengTrackInit {
    //[MobClick setLogEnabled:YES];
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = @"5665541ee0f55aedfc0034f4";
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)umengShareInit{
    @try {
        [UMSocialData setAppKey:@"5665541ee0f55aedfc0034f4"];
        //qq分享
        [UMSocialQQHandler setQQWithAppId:@"1105009062" appKey:@"V5H2L8ij9BNx6qQw" url:@"https://www.umeng.com/social"];
        //微信分享
        [UMSocialWechatHandler setWXAppId:@"3c7b4e3eb5ae4cfb132b2ac060a872ee" appSecret:@"wx25fcb32689872499" url:@"https://www.umeng.com/social"];
        //微博分享
        [WeiboSDK registerApp:@"2475629754"];
        [WXApi registerApp:@"wx25fcb32689872499" withDescription:@"weixin"];
    } @catch (NSException *exception) {
        NSLog(@"DEBUG: failure to batch update.  %@", exception.description);
    } @finally {
        
    }

}
- (void)getLaunchImage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/activitys/startup_diagrams",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.imageUrl = responseObject[@"picture"];
//        NSURL *url = [NSURL URLWithString:[[self.imageUrl ImageNoCompression] JMUrlEncodedString]];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imagewithURLString:[NSString stringWithFormat:@"%@?imageMogr2/thumbnail/1320/format/jpg/quality/90",self.imageUrl]];
            [JMStoreManager removeFileByFileName:@"launchImageCache"];
            [JMStoreManager saveDataFromImage:image WithFilePath:@"launchImageCache" Quality:0.5];
        });
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) { 
        
    }];
}
- (void)fetchRootVC {
    JMHomeRootController *root = [[JMHomeRootController alloc] init];
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
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //注意!!!umeng必须要在udesk初始化之后，否则umeng crasklog会不生效，可能udesk自己捕获了一些crash信号处理
    [self udeskInit];
    [self umengTrackInit];
    [[JMGlobal global] monitoringNetworkStatus];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPushMessage) name:@"openPushMessageSwitch" object:nil];
    [self getServerIP];
    [self updateLoginState];
    /**
     *  检测是否是第一次打开  -- 并且记录打开的次数
     */
    [JMStoreManager recoderAppLoadNum];
    self.isFirst = YES;
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsReceivePushTZ];
    if ([string isEqual:@"1"] || string == nil) {
        [MiPushSDK registerMiPush:self type:0 connect:YES];
    }else { }
    
    [self umengShareInit];
    //创建导航控制器，添加根视图控制器
    [self getLaunchImage];
    [self fetchRootVC];
    if (launchOptions != nil) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification != nil) {
            self.pushInfo = remoteNotification;
            self.isLaunchedByNotification = YES;
        }
    }
    // -- 添加UserAgent
    [self createUserAgent];
    // 是否清除缓存的判断,这里处理每隔2天清除自动清除一次
    if ([[JMGlobal global] currentTimeWithBeforeDays:-2]) {
        [[JMGlobal global] clearCacheWithSDImageCache:^(NSString *sdImageCacheString) {
        }];
    }
    
    return YES;
}

- (void)openPushMessage {
    [MiPushSDK registerMiPush:self type:0 connect:YES];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        NSDictionary *result = responseObject;
        if (([result objectForKey:@"id"] != nil)  && ([[result objectForKey:@"id"] integerValue] != 0)) {
            // 手机登录成功 ，保存用户信息以及登录途径
            [defaults setBool:YES forKey:kIsLogin];
            NSLog(@"Still logined");
        } else{
            // 手机登录需要 ，保存用户信息以及登录途径
            [defaults setBool:NO forKey:kIsLogin];
            NSLog(@"maybe cookie timeout,need login");
        }
    } WithFail:^(NSError *error) {
        // 手机登录需要 ，保存用户信息以及登录途径
        [defaults setBool:NO forKey:kIsLogin];
        NSLog(@"maybe cookie timeout,need login");
    } Progress:^(float progress) {
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
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSUInteger iCount = deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    self.deviceToken = deviceTokenString1;
    self.deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [MiPushSDK bindDeviceToken:deviceToken];
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MiPushSDK handleReceiveRemoteNotification :userInfo];
    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}
// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
}
// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}
#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    if ([selector isEqualToString:@"registerMiPush:type:connect:"]) {
    } else if ([selector isEqualToString:@"bindDeviceToken:"]){
        NSLog(@"data = %@", data);
        self.miRegid = [data objectForKey:@"regid"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"regid" message:self.miRegid delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
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
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
            if (!responseObject) return ;
            NSLog(@"JSON: %@", responseObject);
            NSString *user_account = [responseObject objectForKey:@"user_account"];
            if ((user_account != nil) && ![user_account isEqualToString:@""]){
                [MiPushSDK setAccount:user_account];
                //保存user_account
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:user_account forKey:@"user_account"];
                [user synchronize];
//                NSString *infoString = [NSString stringWithFormat:@"--%@--",user_account];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"user_account" message:infoString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
            }
        } WithFail:^(NSError *error) {
        } Progress:^(float progress) {
        }];
        NSString *urlString2 = [NSString stringWithFormat:@"%@/rest/v1/push/topic",Root_URL];
        [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString2 WithParaments:nil WithSuccess:^(id responseObject) {
            if (!responseObject) return;
            NSArray *arr = responseObject[@"topics"];
            for (NSString *str in arr) {
                [MiPushSDK subscribe:str];
            }
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
        }];

        
    }else if ([selector isEqualToString:@"setAccount:"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"user_account" message:@"setaccount succ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];

    }

    
}
- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data {
    NSLog(@"请求失败");
    // 请求失败
//    NSString *errString = [NSString stringWithFormat:@"mipush command error(%d|%@): %@", error, [self getOperateType:selector], data];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"content" message:errString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}
- (void)miPushReceiveNotification:(NSDictionary *)data {
    NSLog(@"---------------data = %@", data);
    if(data == nil) return;
    NSDictionary *apsDic = data[@"aps"];
    NSString *jsonString = apsDic[@"alert"];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    if ((jsonDic != nil) && (jsonDic[@"type"]!=nil) && [jsonDic[@"type"] isEqual:@"mama_ordercarry_broadcast"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubscribeMessage" object:jsonDic[@"content"]];
    }else {
    }
//    NSString *infoString = [NSString stringWithFormat:@"miPushReceiveNotification %@",data];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"content" message:infoString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
        // 长连接收到的消息。消息格式跟APNs格式一样
        // 返回数据
    NSString *target_url = nil;
    target_url = [data objectForKey:@"target_url"];
    
    if (target_url != nil) {
        if (self.isLaunchedByNotification == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
            return;
        }
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil userInfo:@{@"target_url":target_url}];
            return;
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
        }
    }
}

#pragma mark ======== 监听系统事件 application启动过程 ========
// 添加你自己的挂起前准备代码
- (void)applicationWillResignActive:(UIApplication *)application {
}
// 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
// 程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
// 添加你的恢复代码
- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [self updateLoginState];
    if (_isFirst == YES && self.isLaunchedByNotification == YES) {
        _isFirst = NO;
        if ((self.pushInfo == nil) || [self.pushInfo objectForKey:@"target_url"] == nil) {
        } else {
            dispatch_after(1.0f, dispatch_get_main_queue(), ^(void){ // 2
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":[self.pushInfo objectForKey:@"target_url"]}];
            });
        }
    }
}
// 接收到内存警告时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
// 程序即将退出 -- > 在这里添加退出前的清理代码以及其他工作代码
- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark ======== 支付,分享 回调 ========
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [self xiaoluPay:url];
    return [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [self xiaoluPay:url];
    return [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    [self xiaoluPay:url];
    return [UMSocialSnsService handleOpenURL:url];
}
- (void)xiaoluPay:(NSURL *)url {
    [JMPayment handleOpenURL:url WithErrorCodeBlock:^(JMPayError *error) {
        if (error.errorStatus == payMentErrorStatusSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhifuSeccessfully" object:nil];
        }else if (error.errorStatus == payMentErrorStatusFail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CancleZhifu" object:nil];
        }else { }
    }];
    
}


#pragma mark ======== User_Agent ========
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





#pragma mark ======== RESideMenu Delegate ========
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLeftMenuVC" object:nil];
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






































