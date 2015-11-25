//
//  LogInViewController.m
//  XLMM
//
//  Created by younishijie on 15/7/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
//#import "SetPasswordViewController.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "VerifyPhoneViewController.h"



@interface LogInViewController ()

@end


@implementation LogInViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _userIDTextField.text = [userDefault objectForKey:kUserName];
    _passwordTextField.text = [userDefault objectForKey:kPassWord];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userIDTextField.text forKey:kUserName];
    [userDefaults setObject:_passwordTextField.text forKey:kPassWord];
    [userDefaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"登录" selecotr:@selector(btnClicked:)];

    self.passwordTextField.secureTextEntry = YES;

    self.registerButton.backgroundColor = [UIColor clearColor];
    self.registerButton.layer.cornerRadius = 20;
    self.registerButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.registerButton.layer setBorderWidth:1];
    
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    [self.loginButton.layer setBorderWidth:1];
    
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -----UITextFieldDelegate 

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTextField resignFirstResponder];
    [self.userIDTextField resignFirstResponder];
  
}

- (IBAction)loginClicked:(UIButton *)sender {
    NSLog(@"登录");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *userName = _userIDTextField.text;
    NSString *password = _passwordTextField.text;
    
    NSLog(@"userName : %@, password : %@", userName, password);
    
    
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password
                                 };
   
    
    
    [manager POST:kLOGIN_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
              NSLog(@"JSON: %@", responseObject);
              
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"null"]) {
              }
              // result = null;
              
              //  result = "u_error";
              //  result = "p_error";
              
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"u_error"]) {
              }
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"p_error"]) {
              }
              
              
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"login"]) {
                  NSLog(@"succeed");
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  // 手机登录成功 ，保存用户信息以及登录途径
                  [defaults setBool:YES forKey:kIsLogin];
                  NSDictionary *userInfo = @{kUserName:self.userIDTextField.text,
                                             kPassWord:self.passwordTextField.text};
                  [defaults setObject:userInfo forKey:kPhoneNumberUserInfo];
                  [defaults setObject:kPhoneLogin forKey:kLoginMethod];
                  [defaults synchronize];
                  // 发送手机号码登录成功的通知
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
                  [self.navigationController popViewControllerAnimated:NO];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              
          }];
}

- (IBAction)forgetPasswordClicked:(UIButton *)sender {
    NSLog(@"忘记密码");
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (IBAction)registerClicked:(UIButton *)sender {
    NSLog(@"注册");
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    [self.navigationController pushViewController:verifyVC animated:YES];
    //RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    //[self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)seePasswordButtonClicked:(id)sender {
    UIImage *image = nil;
    if (self.passwordTextField.secureTextEntry) {
        image = [UIImage imageNamed:@"display_passwd_icon.png"];
    } else {
        image = [UIImage imageNamed:@"hide_passwd_icon.png"];
    }
    [self.displayHidePasswdButton setImage:image forState:UIControlStateNormal];
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

- (IBAction)weixinButtonClicked:(id)sender {
}
@end
