//
//  MMRootViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

@interface MMRootViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, RootVCPushOtherVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)btnClicked:(id)sender;

@end