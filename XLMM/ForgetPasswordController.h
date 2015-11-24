//
//  ForgetPasswordController.h
//  XLMM
//
//  Created by younishijie on 15/11/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *codeButtonLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@property (weak, nonatomic) IBOutlet UIButton *obtainCodeButton;


@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)obtainButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
