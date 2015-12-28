//
//  TodayViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMNavigationDelegate.h"
#import "SRRefreshView.h"

@interface TodayViewController : UIViewController<SRRefreshDelegate>

@property (nonatomic, assign) id<MMNavigationDelegate>delegate;


@end
