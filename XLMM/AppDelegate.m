//
//  AppDelegate.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AppDelegate.h"

#import "Pingpp.h"
#import "MMRootViewController.h"
#import "LeftMenuViewController.h"
#import "AFNetworking.h"
#import "MMClass.h"

#import "NewLeftViewController.h"

#define login @"login"

@interface AppDelegate ()

@property (nonatomic ,copy) NSString *wxCode;
@property (nonatomic ,copy) NSString *access_token;
@property (nonatomic ,copy) NSString *openid;
@property (nonatomic, strong) NSDictionary *tokenInfo;
@property (nonatomic, strong) NSDictionary *userInfo;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    NSLog(@"%@", plistPath1);
    
    [WXApi registerApp:@"wx25fcb32689872499" withDescription:@"weixin"];
    
    
    
    //创建导航控制器，添加根视图控制器

    
    // 设置登录状态
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    NSLog(@"userDefaults = %@", userDefualts);
    
    NSString *username = [userDefualts objectForKey:kUserName];
    NSString *password = [userDefualts objectForKey:kPassWord];
    
    NSLog(@"username = %@", username);
    NSLog(@"password = %@", password);
    if (username != nil && password != nil && password.length > 3) {
        NSLog(@"自动登录");
        
        
       // [self autoLoginWithUsername:username andPassword:password];
       // [userDefualts setBool:YES forKey:login];
        
    }
    else{
        NSLog(@"手动登录");
        [userDefualts setBool:NO forKey:login];

    }
    [userDefualts synchronize];
    
  
    
    
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
    menuVC.view.backgroundColor = [UIColor colorWithR:38 G:38 B:46 alpha:1];
    menuVC.menuPreferredStatusBarStyle = 1;
    menuVC.delegate = self;
    menuVC.contentViewShadowColor = [UIColor blackColor];
    menuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    menuVC.contentViewShadowOpacity = 0.6;
    menuVC.contentViewShadowRadius = 12;
    menuVC.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = menuVC;
    

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    NSLog(@"---Token--%@", pToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

- (BOOL)autoLoginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    NSLog(@"userName : %@, password : %@", username, password);
    
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password
                                 };
    NSLog(@"parameters = %@", parameters);
    
    [manager POST:kLOGIN_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
              //登录成功
              [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kIsLogin];
              [[NSUserDefaults standardUserDefaults] synchronize];
           
              
            
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //登录失败
              
              NSLog(@"Error: %@", error);
              [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kIsLogin];
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              
          }];
    
    return YES;
    
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //收到本地推送消息后调用的方法
    NSLog(@"%@",notification);
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    NSLog(@"%@----%@",identifier,notification);
    completionHandler();//处理完消息，最后一定要调用这个代码块
}



-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}




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
       
    } else {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            
            self.wxCode = code;
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:code forKey:@"wxCode"];
            [userDefaults synchronize];
            
            
            NSDictionary *dic = @{@"code":code};
            NSLog(@"dic11111 = %@", dic);
            
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

                
                NSLog(@"tokeninfo = %@", self.tokenInfo);
                
                NSLog(@"userInfo = %@", self.userInfo);
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:self.userInfo forKey:@"userInfo"];
                [userdefault synchronize];
                
                
                //                self.nickname.text = [dic objectForKey:@"nickname"];
                //                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                NSLog(@"name = %@", [dic objectForKey:@"nickname"]);
                
                NSNotification * broadcastMessage = [ NSNotification notificationWithName: @"login" object: self ];
                NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                [notificationCenter postNotification: broadcastMessage];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogin];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"登录成功");
                
                //传递参数：
                
                
                
            }
        });
        
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [WXApi handleOpenURL:url delegate:self];;
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
                   NSLog(@"支付成功");
                   
                   
               } else {
                   // 支付失败或取消
                   NSLog(@"取消支付或支付失败");
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"CancleZhifu" object:nil];
                   NSLog(@"AppDelegate ... Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
               }
           }];
    
    
    return  [WXApi handleOpenURL:url delegate:self];
}
#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}



@end
