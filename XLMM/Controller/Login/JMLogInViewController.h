//
//  JMLogInViewController.h
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JMLogInViewController : UIViewController
@property (nonatomic,strong) NSString *returnUrl;

@property (nonatomic, assign) BOOL isFirstLogin;
@property (nonatomic, assign) BOOL isTabBarLogin;


@end
