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
#import "UIViewController+NavigationBar.h"


@interface RegisterViewController ()
{
    NSTimer *countDownTimer;
    
    int secondsCountDown;
}
@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    
    [self createNavigationBarWithTitle:@"注册" selecotr:@selector(btnClicked:)];
    self.infoLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
    secondsCountDown = 60;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _setPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _resetPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _numberTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _setPasswordTextField.borderStyle = UITextBorderStyleNone;
    _resetPasswordTextField.borderStyle = UITextBorderStyleNone;
    
    
    _numberTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _setPasswordTextField.backgroundColor = [UIColor whiteColor];
    _resetPasswordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.delegate = self;
    _numberTextField.delegate = self;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _setPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _resetPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _setPasswordTextField.delegate = self;
    _resetPasswordTextField.delegate = self;
    
}

- (void)btnClicked:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@/rest/v1/register/check_code_user", Root_URL];
    NSLog(@"url = %@", stringUrl);
    [manager POST:stringUrl parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  NSError *error;
              NSLog(@"JSON: %@", responseObject);
                          // [self.navigationController popViewControllerAnimated:YES];
         
              if (![self.setPasswordTextField.text isEqualToString:self.resetPasswordTextField.text]) {
                  self.passwordLabel.text = @"两次密码输入不一样，请重新输入!";
                  self.passwordLabel.hidden = NO;
                  return ;
              }
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

- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)getPasswordButtonClicked:(UIButton *)sender {
    NSLog(@"获得验证码");
    NSString *phoneNumber = _numberTextField.text;
    if (phoneNumber.length != 11) {
        self.infoLabel.text = @"请输入正确的手机号码!";
        self.infoLabel.hidden = NO;
        return;
    }
    if (![self isAllNum:phoneNumber]) {
        self.infoLabel.text = @"请输入正确的手机号码!";
        self.infoLabel.hidden = NO;
        return;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"phoneNumber = %@\n", _numberTextField.text);
    NSDictionary *parameters = @{@"vmobile": phoneNumber};
    
    
    NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/register", Root_URL];
    NSLog(@"url = %@", stringurl);
    
    [manager POST:stringurl parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"JSON: %@", responseObject);
             NSString *string = [responseObject objectForKey:@"result"];
             if ([string isEqualToString:@"false"]) {
                 self.infoLabel.text = @"请输入正确的手机号码!";
                 self.infoLabel.hidden = NO;
             } else if([string isEqualToString:@"0"]){
                 self.infoLabel.hidden = NO;
                 self.infoLabel.text = @"该手机号码已经注册过了!";
             } else{
                 self.infoLabel.hidden = YES;
             }
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
             _getCodeBtn.userInteractionEnabled = NO;
             [_getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//             [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码%02d秒",secondsCountDown] forState:UIControlStateNormal];
             
             //[self.navigationController popViewControllerAnimated:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             
         }];

}
- (void)timeFireMethod
{
    secondsCountDown--;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码%02d秒",secondsCountDown] forState:UIControlStateNormal];
    
    if (secondsCountDown == 55)
    {
        secondsCountDown=60;
        [countDownTimer invalidate];
        
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTextField resignFirstResponder];
    [self.setPasswordTextField resignFirstResponder];
    [self.resetPasswordTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
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
