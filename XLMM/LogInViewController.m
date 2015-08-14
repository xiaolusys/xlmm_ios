//
//  LogInViewController.m
//  XLMM
//
//  Created by younishijie on 15/7/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "ModifyPasswordViewController.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "MMClass.h"


@interface LogInViewController ()

@end

@implementation LogInViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _userIDTextField.text = [userDefault objectForKey:kUserName];
    _passwordTextField.text = [userDefault objectForKey:kPassWord];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.infoLabel.hidden = YES;
    _userIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.secureTextEntry = YES;
    
    
    
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

- (IBAction)loginClicked:(UIButton *)sender {
    NSLog(@"登录");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *userName = _userIDTextField.text;
    NSString *password = _passwordTextField.text;
    
    NSLog(@"userName : %@, password : %@", userName, password);
    
    
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password
                                 };
    MMLOG(parameters);

    
    [manager POST:kLOGIN_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
              MMLOG(operation);
              NSLog(@"JSON: %@", responseObject);
              
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"null"]) {
                  NSLog(@"用户名和密码不能为空");
                  self.infoLabel.text = @"用户名和密码不能为空!";
                  self.infoLabel.hidden = NO;
              }
             // result = null;

            //  result = "u_error";
            //  result = "p_error";

              if ([[responseObject objectForKey:@"result"] isEqualToString:@"u_error"]) {
                  NSLog(@"用户名错误");
                  self.infoLabel.text = @"用户名错误!";
                  self.infoLabel.hidden = NO;
              }
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"p_error"]) {
                  NSLog(@"密码错误");
                  self.infoLabel.text = @"密码错误!";
                  self.infoLabel.hidden = NO;
              }
              
              
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"login"]) {
                  NSLog(@"succeed");
                  self.infoLabel.text = @"登录成功!";
                  self.infoLabel.hidden = NO;
                  [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kIsLogin];
                  [self.navigationController popToRootViewControllerAnimated:YES];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              MMLOG(operation);
              NSLog(@"Error: %@", error);
              
              
          }];
}

- (IBAction)forgetPasswordClicked:(UIButton *)sender {
    NSLog(@"忘记密码");
    [self.navigationController pushViewController:[[ModifyPasswordViewController alloc] init] animated:YES];
}

- (IBAction)registerClicked:(UIButton *)sender {
    NSLog(@"注册");
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
@end
