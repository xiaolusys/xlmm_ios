//
//  ModifyPasswordViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;



- (IBAction)confirmClicked:(id)sender;

- (IBAction)getCode:(id)sender;

@end
