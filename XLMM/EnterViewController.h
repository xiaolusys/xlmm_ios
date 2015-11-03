//
//  EnterViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/11.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterViewController : UIViewController
- (IBAction)mmLogin:(id)sender;
- (IBAction)weixinLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UIButton *zhanghaoButton;

@end
