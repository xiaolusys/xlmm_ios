//
//  JMMiPushManager.m
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMiPushManager.h"

@interface JMMiPushManager (){
    NSString *_deviceToken;
    NSString *_deviceUUID;
    NSString *_miRegid;
    BOOL _isLaunchedByNotification;
    NSDictionary *_pushInfo;
    BOOL _isFirst;
}


@end

@implementation JMMiPushManager


+ (instancetype)miPushManager {
    static JMMiPushManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JMMiPushManager alloc] init];
    });
    return manager;
}
- (void)finishLaunchingWithOptions:(NSDictionary *)launchOptions First:(BOOL)first {
    _isFirst = first;
    if (launchOptions != nil) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification != nil) {
            _pushInfo = remoteNotification;
            _isLaunchedByNotification = YES;
        }
    }
    
}


- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSUInteger iCount = deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    _deviceToken = deviceTokenString1;
    _deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [MiPushSDK bindDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application ReceiveRemoteNotification:(NSDictionary *)userInfo {
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

- (void)presentNotification:(UNNotification *)notification {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    
}
- (void)receiveNotificationResponse:(UNNotificationResponse *)response {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
}

#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    if ([selector isEqualToString:@"registerMiPush:type:connect:"]) {
    } else if ([selector isEqualToString:@"bindDeviceToken:"]){
        NSLog(@"data = %@", data);
        _miRegid = [data objectForKey:@"regid"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"regid" message:self.miRegid delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
        NSLog(@"%@ %@", _deviceUUID, _deviceToken);
        NSDictionary *parameters = @{@"platform":@"ios",
                                     @"regid":_miRegid,
                                     @"device_id":_deviceUUID,
                                     @"ios_token":_deviceToken
                                     };
        [JMUserDefaults setObject:parameters forKey:@"MiPush"];
        [JMUserDefaults synchronize];
        NSLog(@"parameters = %@", parameters);
        NSLog(@"urlStr = %@", urlString);
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
            if (!responseObject) return ;
            NSLog(@"JSON: %@", responseObject);
            NSString *user_account = [responseObject objectForKey:@"user_account"];
            if ((user_account != nil) && ![user_account isEqualToString:@""]){
                [MiPushSDK setAccount:user_account];
                //保存user_account
                [JMUserDefaults setObject:user_account forKey:@"user_account"];
                [JMUserDefaults synchronize];
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
        [JMNotificationCenter postNotificationName:@"SubscribeMessage" object:jsonDic[@"content"]];
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
        if (_isLaunchedByNotification == YES) {
            [JMNotificationCenter postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
            return;
        }
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            //            [JMNotificationCenter postNotificationName:@"Notification" object:nil userInfo:@{@"target_url":target_url}];
            return;
        } else {
            [JMNotificationCenter postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":target_url}];
        }
    }
}
- (void)didBecomeActive {
    if (_isFirst == YES && _isLaunchedByNotification == YES) {
        _isFirst = NO;
        NSLog(@"%@",_pushInfo);
        if ((_pushInfo == nil) || [_pushInfo objectForKey:@"target_url"] == nil) {
        } else {
            dispatch_after(1.0f, dispatch_get_main_queue(), ^(void){ // 2
                [JMNotificationCenter postNotificationName:@"PresentView" object:nil userInfo:@{@"target_url":[_pushInfo objectForKey:@"target_url"]}];
            });
        }
    }
    
    
}












@end
















































































































