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
#import "AFNetworking.h"
#import "MMClass.h"


#define PHONE_NUM_LIMIT 11
#define VERIFY_CODE_LIMIT 6
#define COUNTING_LIMIT 60


@interface VerifyPhoneViewController ()<UITextFieldDelegate>
{
    NSTimer *countDownTimer;
    NSInteger secondsCountDown;
    BOOL _isSettingPassword;
}
@end

@implementation VerifyPhoneViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    secondsCountDown = 60;
    
    [self createNavigationBarWithTitle:self.config[@"title"] selecotr:@selector(backClicked:)];
    
    self.codeTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.obtainCodeButton.layer.cornerRadius = 15;
    self.obtainCodeButton.layer.borderWidth = 0.5;
    self.obtainCodeButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    if ([self.config[@"isMessageLogin"] boolValue]) {
        [self.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }
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
    [self startCountingDown];
    
    NSString *phoneNumber = self.phoneNumberTextField.text;

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = nil;
    
    
    NSString *stringurl = TSendCode_URL;;
    
    if ([self.config[@"isRegister"] boolValue] == YES && [self.config[@"isMessageLogin"] boolValue] == NO){
        //手机注册
        parameters = @{@"mobile": phoneNumber, @"action":@"register"};
    }else if ([self.config[@"isUpdateMobile"] boolValue] == YES){
        //修改密码
        parameters = @{@"mobile": phoneNumber, @"action":@"change_pwd"};
    }else if ([self.config[@"isMessageLogin"] boolValue] ==   YES){
        //短信登录
        parameters = @{@"mobile": phoneNumber, @"action":@"sms_login"};
    }else if ([self.config[@"isVerifyPsd"] boolValue] == YES) {
        //忘记密码
        parameters = @{@"mobile": phoneNumber, @"action":@"find_pwd"};
    }
    
    NSLog(@"url = %@", stringurl);
    NSLog(@"paramters = %@", parameters);
    
    [manager POST:stringurl parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self alertMessage:[responseObject objectForKey:@"msg"]];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
    }];
}

-(void) startCountingDown
{
    secondsCountDown = COUNTING_LIMIT;
    [self.obtainCodeButton setTitle:@"" forState:UIControlStateNormal];
    [self disableCodeButton];
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void) stopCountingDown
{
    [countDownTimer invalidate];
    [self.obtainCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self enableCodeButton];
}


- (void)timeFireMethod
{
    secondsCountDown--;
    self.countingLabel.text = [NSString stringWithFormat:@"%lu秒",(long)secondsCountDown];
    
    if (secondsCountDown <= 0)
    {
        [self stopCountingDown];
        self.countingLabel.text = @"";
    }
}

- (void) alertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) displaySetPasswordPage
{
    SetPasswordViewController *setPasswordVC = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
    
    if ([self.config[@"isVerifyPsd"] boolValue]){
        //忘记密码
        setPasswordVC.config = @{@"title":@"设置密码",@"isVerifyPsd":@YES,@"phone":self.phoneNumberTextField.text,@"vcode":self.codeTextField.text,@"text1":@"请输入6-16位登录密码"};
    }else{
        //修改密码 设置密码
        setPasswordVC.config = @{@"title":@"重置密码",@"isUpdateMobile":@NO,@"phone":self.phoneNumberTextField.text,@"vcode":self.codeTextField.text,@"text1":@"请输入6-16位新密码"};
    }
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}

- (IBAction)nextButtonClicked:(id)sender {
    //NSLog(@"验证验证码是否正确");
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSString *phoneNumber = self.phoneNumberTextField.text;
//    NSString *vcode = self.codeTextField.text;
//    if ([self.config[@"isMessageLogin"] boolValue]) {
//        //短信验证
//        NSDictionary *parameters = @{@"mobile":phoneNumber,@"action":@"sms_login", @"verify_code":vcode};
//        NSLog(@"dic = %@", parameters);
//        NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/register/sms_login", Root_URL];
//        NSLog(@"url = %@", stringurl);
//        
//        [manager POST:stringurl parameters:parameters
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSLog(@"responseObject = %@", responseObject);
//                  //                  responseObject = {
//                  //                      code = 0;
//                  //                      info =     {
//                  //                          created = "2015-12-03T15:04:49";
//                  //                          email = "";
//                  //                          "has_usable_password" = 1;
//                  //                          id = 665152;
//                  //                          mobile = 13816404857;
//                  //                          modified = "2015-12-03T15:04:49";
//                  //                          nick = "";
//                  //                          phone = "";
//                  //                          score = 0;
//                  //                          status = 1;
//                  //                          url = "http://m.xiaolu.so/rest/v1/users/665152";
//                  //                          "user_id" = 665297;
//                  //                          username = 13816404857;
//                  //                          xiaolumm = "<null>";
//                  //                      };
//                  //                  }
//                  if ([[[responseObject objectForKey:@"info"] objectForKey:@"has_usable_password"] integerValue] == 1){   // 校验成功。。。
//                      
//                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                      // 手机登录成功 ，保存用户信息以及登录途径
//                      [defaults setBool:YES forKey:kIsLogin];
//                    
//                      [defaults synchronize];
//                      
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
//                      [self.navigationController popToRootViewControllerAnimated:YES];
//                      //                      [self displaySetPasswordPage];
//                  }else{
//                      [self displaySetPasswordPage];
//                  }
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  NSLog(@"Error: %@", error);
//              }];
//        
//
//        
//        
//    } else {
//        //手机注册校验验证码
//        NSDictionary *parameters = @{@"mobile":phoneNumber, @"action":@"register", @"verify_code":vcode};
//        NSLog(@"dic = %@", parameters);
////        NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/register/check_vcode", Root_URL];
//        NSLog(@"url = %@", TVerifyCode_URL);
//        [manager POST:TVerifyCode_URL parameters:parameters
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSLog(@"responseObject = %@", responseObject);
//                  NSLog(@"msg = %@", responseObject[@"msg"]);
//                  [self alertMessage:[responseObject objectForKey:@"msg"]];
//                  if ([[responseObject objectForKey:@"rcode"] integerValue] == 0) {
//                      //设置用户名在newLeft中使用
//                      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                      [user setObject:phoneNumber forKey:kUserName];
//                      [user setBool:YES forKey:kIsLogin];
//                      //发送通知在root中接收
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
//                      [self.navigationController popToRootViewControllerAnimated:YES];
//                  }
//            }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  NSLog(@"Error: %@", error);
//              }];
//    }
  
    NSString *phoneNumber = self.phoneNumberTextField.text;
    NSString *vcode = self.codeTextField.text;

    NSDictionary *parameters = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([self.config[@"isMessageLogin"] boolValue]) {
        parameters = @{@"mobile":phoneNumber,@"action":@"sms_login", @"verify_code":vcode, @"devtype":LOGINDEVTYPE};
    }else if ([self.config[@"isRegister"] boolValue]){
        parameters = @{@"mobile":phoneNumber, @"action":@"register", @"verify_code":vcode,  @"devtype":LOGINDEVTYPE};
    }else if ([self.config[@"isVerifyPsd"] boolValue]){
        parameters = @{@"mobile":phoneNumber, @"action":@"find_pwd", @"verify_code":vcode};
    }else if ([self.config[@"isUpdateMobile"] boolValue]) {
        parameters = @{@"mobile":phoneNumber, @"action":@"change_pwd", @"verify_code":vcode};
    }
    
    [manager POST:TVerifyCode_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self verifyAfter:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)verifyAfter:(NSDictionary *)dic {
    if (dic.count == 0)return;
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if ([[dic objectForKey:@"rcode"] integerValue] != 0){
        [self alertMessage:[dic objectForKey:@"msg"]];
        return;
    }
    if ([self.config[@"isRegister"] boolValue] || [self.config[@"isMessageLogin"] boolValue]) {
        [self alertMessage:[dic objectForKey:@"msg"]];
        //设置用户名在newLeft中使用
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:phoneNumber forKey:kUserName];
        [user setBool:YES forKey:kIsLogin];
        //发送通知在root中接收
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([self.config[@"isVerifyPsd"] boolValue] || [self.config[@"isUpdateMobile"] boolValue]) {
        [self displaySetPasswordPage];
    }
}
@end



