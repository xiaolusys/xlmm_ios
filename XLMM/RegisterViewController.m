//
//  RegisterViewController.m
//  XLMM
//
//  Created by younishijie on 15/7/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "MMClass.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.infoLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _setPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _resetPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.delegate = self;
    _numberTextField.delegate = self;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _setPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _resetPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _setPasswordTextField.delegate = self;
    _resetPasswordTextField.delegate = self;
    
}



- (IBAction)registerButtonClicked:(UIButton *)sender {
    
    
    NSLog(@"注册");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *phoneNumber = _numberTextField.text;
    NSString *validCode = _passwordTextField.text;
    NSString *password1 = _setPasswordTextField.text;
    NSString *password2 = _resetPasswordTextField.text;
    
    NSLog(@"username:%@, validcode:%@, password1:%@, password2:%@", phoneNumber, validCode, password1, password2);
    
   
   NSDictionary *parameters = @{@"username": phoneNumber,
                                @"valid_code":validCode,
                                @"password1":password1,
                                @"password2":password2,
                                };
    
    [manager POST:@"http://192.168.1.41:8000/rest/v1/register/check_code_user" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];


}

- (IBAction)getPasswordButtonClicked:(UIButton *)sender {
    NSLog(@"获得验证码");
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *phoneNumber = _numberTextField.text;
    NSLog(@"phoneNumber = %@\n", _numberTextField.text);
    NSDictionary *parameters = @{@"vmobile": phoneNumber};
    
    [manager POST:@"http://192.168.1.41:8000/rest/v1/register" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"JSON: %@", responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             
         }];

}

#pragma mark ----UITextFieldDelegate-----



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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


@end
