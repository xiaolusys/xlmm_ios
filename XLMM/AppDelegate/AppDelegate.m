//
//  AppDelegate.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AppDelegate.h"
#import "JMStoreManager.h"
#import "Udesk.h"
#import "JMPayment.h"
#import "JMMiPushManager.h"
#import "JMHomePageController.h"
#import "JMRootTabBarController.h"
#import "XHLaunchAd.h"
#import "JMLogInViewController.h"


#define login @"login"

#define appleID @"so.xiaolu.m.xiaolumeimei"

@interface AppDelegate () {
    NSString *_imageUrl;
}

@end

@implementation AppDelegate

#pragma mark ======== 友盟统计/分享.uDesk ========
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
#pragma mark ======== 获取启动图数据 ========
- (void)getLaunchImage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/activitys/startup_diagrams",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ; // @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg";
        _imageUrl = responseObject[@"picture"];
        if ([NSString isStringEmpty:_imageUrl]) {
            return ;
        }
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        imageAdconfiguration.duration = 3;
        imageAdconfiguration.frame = [UIScreen mainScreen].bounds;
        imageAdconfiguration.imageNameOrURLString = _imageUrl;
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        imageAdconfiguration.showEnterForeground = NO;
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
//        [self performSelector:@selector(dsfafasf) withObject:nil afterDelay:3.];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) { 
        
    }];
}
- (void)dsfafasf {
    
}
#pragma mark ======== 设置根控制器 ========
- (void)fetchRootVC {
    NSInteger netWorkStatus = [AFNetworkReachabilityManager manager].networkReachabilityStatus;
    if (netWorkStatus == 0) {
        [self rootWithLoginVC];
        return ;
    }
    [self lodaUserInfo];
    [XHLaunchAd setWaitDataDuration:2];
}
- (void)lodaUserInfo {
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        BOOL kIsXLMMStatus = [[responseObject objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
        BOOL kIsBindPhone = ![NSString isStringEmpty:[responseObject objectForKey:@"mobile"]];
        BOOL kIsVIP = NO;
        if (kIsXLMMStatus) {
            NSDictionary *xlmmDict = responseObject[@"xiaolumm"];
            kIsVIP = [xlmmDict[@"last_renew_type"] integerValue] >= 90 ? YES : NO;
        }
        if (kIsVIP) {
            if (kIsBindPhone) {
                [self rootWithTabBar];
                return ;
            }
        }
        [self rootWithLoginVC];
    } failure:^(NSInteger errorCode) {
        [self rootWithLoginVC];
    }];
}
- (void)rootWithTabBar {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    JMRootTabBarController *tabBarVC = [[JMRootTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    [XHLaunchAd cancelWatiTimer];
    [self getLaunchImage];
}
- (void)rootWithLoginVC {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [XHLaunchAd cancelWatiTimer];
    [self getLaunchImage];
}
#pragma mark ======== 程序开始启动 ========
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注意!!!umeng必须要在udesk初始化之后，否则umeng crasklog会不生效，可能udesk自己捕获了一些crash信号处理
    [self udeskInit];
    [self umengTrackInit];
    [[JMGlobal global] monitoringNetworkStatus];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JMNotificationCenter addObserver:self selector:@selector(openPushMessage) name:@"openPushMessageSwitch" object:nil];
    
    [[JMDevice defaultDecice] getServerIP];
    /**
     *  检测是否是第一次打开  -- 并且记录打开的次数
     */
    [JMStoreManager recoderAppLoadNum];
    NSString *string = [JMUserDefaults objectForKey:kIsReceivePushTZ];
    if ([string isEqual:@"1"] || string == nil) {
        [self openPushMessage];
    }else { }
    
    [self umengShareInit];
    [[JMMiPushManager miPushManager] finishLaunchingWithOptions:launchOptions First:YES];
    // -- 添加UserAgent
    [self createUserAgent];
    // 是否清除缓存的判断,这里处理每隔2天清除自动清除一次
    if ([[JMGlobal global] currentTimeWithBeforeDays:-2]) {
        [[JMGlobal global] clearCacheWithSDImageCache:^(NSString *sdImageCacheString) {
        }];
    }
    //创建导航控制器，添加根视图控制器
    [self fetchRootVC];
    
    return YES;
}
- (void)openPushMessage {
    [MiPushSDK registerMiPush:[JMMiPushManager miPushManager] type:0 connect:YES];
}
#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[JMMiPushManager miPushManager] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[JMMiPushManager miPushManager] application:application ReceiveRemoteNotification:userInfo];
}
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    [application registerForRemoteNotifications];
//}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[JMMiPushManager miPushManager] presentNotification:notification];
}
// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[JMMiPushManager miPushManager] receiveNotificationResponse:response];
//    completionHandler();
}
#pragma mark ======== 监听系统事件 application启动过程 ========
// 添加你自己的挂起前准备代码
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive ---> 添加你自己的挂起前准备代码");
}
// 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground ---> 程序进入后台");
}
// 程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground ---> 程序进入前台");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
// 添加你的恢复代码
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive ---> 添加你的恢复代码");
    application.applicationIconBadgeNumber = 0;
//    [self updateLoginState];
    if ([JMMiPushManager miPushManager]) {
        [[JMMiPushManager miPushManager] didBecomeActive];
    }
}
// 接收到内存警告时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"applicationDidReceiveMemoryWarning ---> 接收到内存警告时候调用");
    [[JMGlobal global] clearAllSDCache];
}
- (void)dealloc {
    NSLog(@"dealloc ---> dealloc调用");
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [JMNotificationCenter removeObserver:self name:@"openPushMessageSwitch" object:nil];
}
// 程序即将退出 -- > 在这里添加退出前的清理代码以及其他工作代码
- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark ======== 支付,分享 回调 ========
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)xiaoluPay:(NSURL *)url {
    return [JMPayment handleOpenURL:url WithErrorCodeBlock:^(JMPayError *error) {
        if (error.errorStatus == payMentErrorStatusSuccess) {
            [JMNotificationCenter postNotificationName:@"ZhifuSeccessfully" object:nil];
        }else if (error.errorStatus == payMentErrorStatusFail) {
            [JMNotificationCenter postNotificationName:@"CancleZhifu" object:nil];
        }else { }
    }];
    
}

#pragma mark ======== User_Agent ========
//从webview获得浏览器中的useragent，并进行更新
- (void)createUserAgent {
    [[JMDevice defaultDecice] cerateUserAgent:nil];
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


@end
























//
//
//
//
//#pragma mark ======== RESideMenu Delegate ========
//- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
//{
//    //  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    [JMNotificationCenter postNotificationName:@"presentLeftMenuVC" object:nil];
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//
//









