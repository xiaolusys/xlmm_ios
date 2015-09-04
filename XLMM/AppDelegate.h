//
//  AppDelegate.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

