//
//  JMMiPushManager.h
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiPushSDK.h"

@interface JMMiPushManager : NSObject <MiPushSDKDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)miPushManager;

- (void)finishLaunchingWithOptions:(NSDictionary *)launchOptions First:(BOOL)first;

// 获取deviceToken和UUID
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication *)application ReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)presentNotification:(UNNotification *)notification;

- (void)receiveNotificationResponse:(UNNotificationResponse *)response;

- (void)didBecomeActive;



@end


































































































