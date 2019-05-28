//
//  AppDelegate.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//


//  /Users/younishijie/Library/Developer/CoreSimulator/Devices/3B4F0364-F68F-45B6-94E7-41D0995EA5DB/data/Containers/Data/Application/0CA631EA-E691-4B10-B6A8-1A1B4FC212D3/Documents
//  1051166985

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WeiboSDK.h"
#import "MiPushSDK.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandler)();

@end

