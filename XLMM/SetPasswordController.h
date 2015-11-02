//
//  SetPasswordController.h
//  XLMM
//
//  Created by younishijie on 15/11/2.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil phone:(NSString *)phone code:(NSString *)code;

@property (nonatomic, copy, readonly)NSString *phone;
@property (nonatomic, copy, readonly)NSString *code;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
- (IBAction)commitBtnClicked:(id)sender;

@end
