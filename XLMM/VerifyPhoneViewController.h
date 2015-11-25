//
//  VerifyPhoneViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyPhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@property (weak, nonatomic) IBOutlet UIButton *obtainCodeButton;


@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong,nonatomic) NSDictionary *config;



- (IBAction)obtainButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
