//
//  ModifyPasswordViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MMClass.h"
#import "AFNetworking.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

@end

@implementation ModifyPasswordViewController{
 
    NSTimer *countDownTimer;
    int secondsCountDown;
    UILabel *buttonLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    [self setInfo];
    
    self.infoLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
    
    self.phoneNumberTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberTextField.delegate = self;
    self.passCodeTextField.delegate = self;
    self.setPasswordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    self.phoneNumberTextField.borderStyle = UITextBorderStyleNone;
     self.passCodeTextField.borderStyle = UITextBorderStyleNone;
     self.setPasswordTextField.borderStyle = UITextBorderStyleNone;
     self.confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberTextField.backgroundColor = [UIColor whiteColor];
     self.passCodeTextField.backgroundColor = [UIColor whiteColor];
     self.setPasswordTextField.backgroundColor = [UIColor whiteColor];
     self.confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.setPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    
   // http://youni.huyi.so/rest/v1/register/change_pwd_code
    
    buttonLabel = [[UILabel  alloc] init];
    buttonLabel.text = @"获取验证码";
    buttonLabel.frame = CGRectMake(0, 0, 180, 30);
    secondsCountDown = 60;
    
    
    [self.view addSubview:self.getCodeBtn];
    buttonLabel.textColor = [UIColor blueColor];
    buttonLabel.textAlignment = NSTextAlignmentLeft;
    buttonLabel.font = [UIFont systemFontOfSize:18];
    [self.getCodeBtn addSubview:buttonLabel];
    self.getCodeBtn.backgroundColor = [UIColor orangeColor];
    
    [self.getCodeBtn setTitle:@"" forState:UIControlStateNormal];
}

- (void)setInfo{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"密码修改";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
//    imageView.frame = CGRectMake(8, 8, 8, 16);
//    [button addSubview:imageView];
//    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
}

//- (void)backBtnClicked:(UIButton *)button{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITextFieldDelegate--

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passCodeTextField resignFirstResponder];
    [self.setPasswordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmClicked:(id)sender {
    NSLog(@"确认");
    if (![self.setPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        self.passwordLabel.hidden = NO;
        return;
    } else{
        self.passwordLabel.hidden = YES;
        
        NSLog(@"注册");
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *phoneNumber = _phoneNumberTextField.text;
        NSString *validCode = _passCodeTextField.text;
        NSString *password1 = _setPasswordTextField.text;
        NSString *password2 = _confirmPasswordTextField.text;
        
        NSLog(@"username:%@, validcode:%@, password1:%@, password2:%@", phoneNumber, validCode, password1, password2);
        
        
        if ([self.passCodeTextField.text isEqualToString:@""]) {
            self.passwordLabel.text = @"请输入正确的验证码!";
            self.passwordLabel.hidden = NO;
            return;
        }
        if (![self.setPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
            self.passwordLabel.text = @"两次密码输入不一样，请重新输入!";
            self.passwordLabel.hidden = NO;
            return ;
        }
        
        NSDictionary *parameters = @{@"username": phoneNumber,
                                     @"valid_code":validCode,
                                     @"password1":password1,
                                     @"password2":password2,
                                     };
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/register/change_user_pwd", Root_URL];
        NSLog(@"修改密码");
        MMLOG(string);
        [manager POST:string parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //  NSError *error;
                  NSLog(@"JSON: %@", responseObject);
                  // [self.navigationController popViewControllerAnimated:YES];
                  
                 
             
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
                  
              }];

        
    }
}

- (IBAction)getCode:(id)sender {
    NSLog(@"获得验证码");
    NSString *phoneNumber = _phoneNumberTextField.text;
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
    
    NSLog(@"phoneNumber = %@\n", self.phoneNumberTextField.text);
    NSDictionary *parameters = @{@"vmobile": self.phoneNumberTextField.text};
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/register/change_pwd_code", Root_URL];
    NSLog(@"stringUrl = %@", string);
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
              NSString *string = [responseObject objectForKey:@"result"];
              if ([string isEqualToString:@"false"]) {
                  self.infoLabel.text = @"请输入正确的手机号码!";
                  self.infoLabel.hidden = NO;
                  return ;
              } else if([string isEqualToString:@"0"]){
//                  self.infoLabel.hidden = NO;
//                  self.infoLabel.text = @"该手机号码已经注册过了!";
//                  return ;
              } else{
                  self.infoLabel.hidden = YES;
              }
              countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
              _getCodeBtn.userInteractionEnabled = NO;
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.infoLabel.text = @"请输入正确的手机号码!";
              self.infoLabel.hidden = NO;
              
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

- (void)timeFireMethod
{
    secondsCountDown--;
    buttonLabel.text = [NSString stringWithFormat:@"获取验证码%02d秒",secondsCountDown];
    buttonLabel.textColor = [UIColor darkGrayColor];
    
    if (secondsCountDown == 55)
    {
        secondsCountDown= 60;
        [countDownTimer invalidate];
        
        _getCodeBtn.userInteractionEnabled = YES;
        buttonLabel.text = @"获取验证码";
        buttonLabel.textColor = [UIColor blueColor];
        
    }
    
}

    

@end
