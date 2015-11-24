//
//  ForgetPasswordController.m
//  XLMM
//
//  Created by younishijie on 15/11/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "UIViewController+NavigationBar.h"
#import "UIColor+RGBColor.h"


@interface ForgetPasswordController ()<UITextFieldDelegate>

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [self createNavigationBarWithTitle:@"验证手机号" selecotr:];
    [self createNavigationBarWithTitle:@"验证手机号" selecotr:@selector(backClicked:)];
    
    
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    
    
    
    
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.obtainCodeButton.layer.cornerRadius = 15;
    self.obtainCodeButton.layer.borderWidth = 0.5;
    self.obtainCodeButton.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    
    [self disableNextButton];
    [self disableCodeButton];
    
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)enableCodeButton{
    self.codeButtonLabel.textColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    self.obtainCodeButton.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    self.obtainCodeButton.enabled = YES;
}
- (void)disableCodeButton{
    self.codeButtonLabel.textColor = [UIColor buttonDisabledBorderColor];
    self.obtainCodeButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.obtainCodeButton.enabled = NO;
}

- (void)enableNextButton{
    self.nextButton.enabled = YES;
    self.nextButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.nextButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length == 11) {
            [self enableCodeButton];
        }
        else{
            [self disableCodeButton];
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length == 10 && range.location == 10) {
          
            [self enableCodeButton];
        } else{
           
        }
        if (textField.text.length >= 11) {
            NSRange subrange = {0, 10};
            textField.text = [self.phoneNumberTextField.text substringWithRange:subrange];
            
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


#pragma mark --Button Actions

- (IBAction)obtainButtonClicked:(id)sender {
    NSLog(@"获取验证码");
}

- (IBAction)nextButtonClicked:(id)sender {
    NSLog(@"验证验证码是否正确");
}
@end
