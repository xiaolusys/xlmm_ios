//
//  LeftMenuViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RootVCPushOtherVCDelegate <NSObject>

- (void) rootVCPushOtherVC:(UIViewController *)vc;

@end

@interface LeftMenuViewController : UIViewController

@property (nonatomic, assign)id<RootVCPushOtherVCDelegate>pushVCDelegate;

@end
