//
//  SetPasswordViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/18.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : UIViewController

@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, copy) NSString *phoneString;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (assign, nonatomic) BOOL isPasswordReset;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;

- (IBAction)commitClicked:(id)sender;

@end
