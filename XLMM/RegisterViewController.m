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
    
    [manager POST:@"http://youni.huyi.so/rest/v1/register/check_code_user" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  NSError *error;
              NSLog(@"JSON: %@", responseObject);
                          // [self.navigationController popViewControllerAnimated:YES];
         
              int result = [[responseObject objectForKey:@"result"] intValue];
            
              NSLog(@"result = %d", result);
              if (result == 7) {
                  self.passwordLabel.text = @"恭喜你，注册成功!";
                  self.passwordLabel.hidden = NO;
                  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                  [userDefault setObject:self.numberTextField.text forKey:kUserName];
                  [userDefault setObject:self.setPasswordTextField.text forKey:kPassWord];
                  [userDefault synchronize];
                  
                  
              } else if(result == 0){
                  self.passwordLabel.text = @"该手机已注册，请输入新的手机号";
                  self.passwordLabel.hidden = NO;
              } else if(result == 1){
                  self.passwordLabel.text = @"验证码输入错误，请重新输入";
                  self.passwordLabel.hidden = NO;
              } else if(result == 2){
                  self.passwordLabel.text = @"表单填写有误，请重新输入";
                  self.passwordLabel.hidden = NO;
              } else if(result == 3){
                  self.passwordLabel.text = @"未获取验证码，请先获取验证码";
                  self.passwordLabel.hidden = NO;
              } else if(result == 4){
                  self.passwordLabel.text = @" ";
                  self.passwordLabel.hidden = NO;
              } else if(result == 5){
                  self.passwordLabel.text = @" ";
                  self.passwordLabel.hidden = NO;
              } else if(result == 6){
                  self.passwordLabel.text = @" ";
                  self.passwordLabel.hidden = NO;
              }
             
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
    
    [manager POST:@"http://youni.huyi.so/rest/v1/register" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"JSON: %@", responseObject);
             NSString *string = [responseObject objectForKey:@"result"];
             if ([string isEqualToString:@"false"]) {
                 self.infoLabel.text = @"您输入的号码错误!";
                 self.infoLabel.hidden = NO;
             } else{
                 self.infoLabel.hidden = YES;
             }
             //[self.navigationController popViewControllerAnimated:YES];
             
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
