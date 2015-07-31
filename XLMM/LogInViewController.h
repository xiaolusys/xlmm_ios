//
//  LogInViewController.h
//  XLMM
//
//  Created by younishijie on 15/7/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginClicked:(UIButton *)sender;
- (IBAction)forgetPasswordClicked:(UIButton *)sender;
- (IBAction)registerClicked:(UIButton *)sender;

@end
