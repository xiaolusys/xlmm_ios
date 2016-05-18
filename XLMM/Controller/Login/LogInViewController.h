//
//  LogInViewController.h
//  XLMM
//
//  Created by younishijie on 15/7/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *displayHidePasswdButton;

@property (weak, nonatomic) IBOutlet UILabel *loginIngoLabel;

@property (nonatomic, strong)NSString *returnUrl;

- (IBAction)loginClicked:(UIButton *)sender;
- (IBAction)registerClicked:(UIButton *)sender;
- (IBAction)verifyMessageClicked:(id)sender;

- (IBAction)forgetPasswordClicked:(UIButton *)sender;
- (IBAction)seePasswordButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *weixinHiddenView;

- (IBAction)weixinButtonClicked:(id)sender;

@end
