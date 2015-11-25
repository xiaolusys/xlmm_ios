//
//  VerifyPhoneViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "VerifyPhoneViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIColor+RGBColor.h"

#define PHONE_NUM_LIMIT 11
#define VERIFY_CODE_LIMIT 6


@interface VerifyPhoneViewController ()<UITextFieldDelegate>

@end

@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"验证手机号" selecotr:@selector(backClicked:)];
    
    self.codeTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.obtainCodeButton.layer.cornerRadius = 15;
    self.obtainCodeButton.layer.borderWidth = 0.5;
    self.obtainCodeButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    [self disableNextButton];
    [self disableCodeButton];
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)enableCodeButton{
    self.obtainCodeButton.enabled = YES;
    
    self.obtainCodeButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.obtainCodeButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
}
- (void)disableCodeButton{
    self.obtainCodeButton.enabled = NO;
    self.obtainCodeButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
    [self.obtainCodeButton setTitleColor:[UIColor buttonDisabledBackgroundColor] forState:UIControlStateNormal];
    //self.obtainCodeButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
}

- (void)enableNextButton{
    self.nextButton.enabled = YES;
    self.nextButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.nextButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
}

- (void)disableNextButton{
    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.nextButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --UITextFieldDelegate



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@" "])
    {
        return NO; // cant input
    }
    
    // input or delete
    BOOL increase = NO;
    if (textField.text.length == range.location)
    {
        increase = YES;
    }
    //NSLog(@"%lu -- %lu",textField.text.length,range.location);
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.codeTextField == textField)
    {
        if (increase && range.location >= VERIFY_CODE_LIMIT - 1 && self.nextButton.enabled == NO)
        {
            [self enableNextButton];
        }
        if (!increase && range.location <= VERIFY_CODE_LIMIT - 1 && self.nextButton.enabled == YES)
        {
            [self disableNextButton];
        }
        if ([toBeString length] > VERIFY_CODE_LIMIT)
        {
            textField.text = [toBeString substringToIndex:VERIFY_CODE_LIMIT];
            return NO;
        }
    }
    
    if (self.phoneNumberTextField == textField)
    {
        if (increase && range.location >= PHONE_NUM_LIMIT - 1 && self.obtainCodeButton.enabled == NO)
        {
            [self enableCodeButton];
        }
        if (!increase && range.location <= PHONE_NUM_LIMIT - 1 && self.obtainCodeButton.enabled == YES)
        {
            [self disableCodeButton];
        }
        if ([toBeString length] > PHONE_NUM_LIMIT)
        {
            textField.text = [toBeString substringToIndex:PHONE_NUM_LIMIT];
            return NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.phoneNumberTextField) {
        [self disableCodeButton];
    }
    if (textField == self.codeTextField) {
        [self disableNextButton];
    }    return YES;
}

#pragma mark --Button Actions

- (IBAction)obtainButtonClicked:(id)sender {
    NSLog(@"获取验证码");
}

- (IBAction)nextButtonClicked:(id)sender {
    NSLog(@"验证验证码是否正确");
    SetPasswordViewController *setPasswordVC = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
    setPasswordVC.isPasswordReset = YES;
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}
@end
