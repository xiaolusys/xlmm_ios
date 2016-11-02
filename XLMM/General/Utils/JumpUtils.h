//
//  JumpUtils.h
//  XLMM
//
//  Created by wulei on 4/25/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+NavigationBar.h"

@interface JumpUtils : NSObject
+ (void)jumpToLocation:(NSString *)target_url viewController:(UIViewController *)vc;
+ (void)jumpToCallNativePurchase:(NSDictionary *)data Tid:(NSString *)tid viewController:(UIViewController *)vc;

@end

