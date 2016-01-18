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
#import "WXApi.h"
#import "NSString+Encrypto.h"
#import "WXLoginController.h"
#import "MiPushSDK.h"
#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"

@interface LogInViewController ()

@end


@implementation LogInViewController{
    NSMutableString *randomstring;
    BOOL isBangding;
    BOOL isSettingPsd;
    NSDictionary *dic;
    NSString *phoneNumber;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _userIDTextField.text = [userDefault objectForKey:kUserName];
    _passwordTextField.text = [userDefault objectForKey:kPassWord];
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
    if (islogin) {
       // [self.navigationController popViewControllerAnimated:NO];
        // test ying's change
    }
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self selector: @selector (update:) name: @"login" object: nil ];
    
    
}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        
    }
    self.passwordTextField.secureTextEntry = YES;

    self.registerButton.backgroundColor = [UIColor clearColor];
    self.registerButton.layer.cornerRadius = 20;
    self.registerButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.registerButton.layer setBorderWidth:1];
    
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    [self.loginButton.layer setBorderWidth:1];
    
    [self setloginView];
    
}

- (void)setloginView{
    if ([WXApi isWXAppInstalled]) {
        self.weixinHiddenView.hidden = YES;
    } else {
        self.weixinHiddenView.hidden = NO;
        self.loginIngoLabel.text = @"短信验证码登录";
        
        
    }
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)update:(NSNotificationCenter *)notification{
    NSLog(@"微信一键登录成功， 请您绑定手机号");
    
    dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSLog(@"用户信息 = %@", dic);
    //微信登录 hash算法。。。。
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
    NSLog(@"count = %lu", count);
    int index = 0;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    __unused long time = [timeSp integerValue];
    NSLog(@"time = %ld", (long)time);
    
    for (int i = 0; i<8; i++) {
        index = arc4random()%count;
        // NSLog(@"index = %d", index);
        NSString *string = [randomArray objectAtIndex:index];
        [randomstring appendString:string];
    }
    NSLog(@"%@%@",timeSp ,randomstring);
    //    NSString *secret = @"3c7b4e3eb5ae4c";
    NSString *noncestr = [NSString stringWithFormat:@"%@%@", timeSp, randomstring];
    //获得参数，升序排列
    NSString* sign_params = [NSString stringWithFormat:@"noncestr=%@&secret=%@&timestamp=%@",noncestr, SECRET,timeSp];
    NSLog(@"1.————》%@", sign_params);
    
    NSString *sign = [sign_params sha1];
    NSString *dict;
    
    NSLog(@"sign = %@", sign);
    
    
    //http://m.xiaolu.so/rest/v1/register/wxapp_login
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/register/wxapp_login?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"urlString = %@", urlString);
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    dict = [NSString stringWithFormat:@"headimgurl=%@&nickname=%@&openid=%@&unionid=%@", [dic objectForKey:@"headimgurl"], [dic objectForKey:@"nickname"],[dic objectForKey:@"openid"],[dic objectForKey:@"unionid"]];
    
    NSLog(@"params = %@", dict);
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //  [self showAlertWait];
    
    NSData *data2 = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSLog(@"data");
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data2 options:kNilOptions error:nil];
    
    
    NSLog(@"dictionary = %@", dictionary);
    
    //   http://m.xiaolu.so/rest/v1/users/need_set_info
    
    if ([[dictionary objectForKey:@"info"] isKindOfClass:[NSDictionary class]]) {
        
        if ([[[dictionary objectForKey:@"info"] objectForKey:@"mobile"] isEqualToString:@""]) {
            NSLog(@"未绑定手机号码");
            isBangding = NO;
            
            NSLog(@"%@", [dictionary objectForKey:@"info"]);
            NSLog(@"11isBangDing = %d", isBangding);
            
            
        } else {
            NSLog(@"22已绑定手机号码");
            isBangding = YES;
            
            phoneNumber = [[dictionary objectForKey:@"info"] objectForKey:@"mobile"];
            NSLog(@"%@", phoneNumber);
            NSLog(@"22isBangDing = %d", isBangding);
            //  http://m.xiaolu.so/rest/v1/users/need_set_info
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/need_set_info", Root_URL];
            NSLog(@"string = %@", string);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", result);
            if ([[result objectForKey:@"result"] isEqualToString:@"1"]) {
                // isBangding = NO;
                isSettingPsd = NO;
            } else {
                isSettingPsd = YES;
            }
            
        }
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:YES forKey:@"login"];
    [userdefaults synchronize];
    [self loginSuccessful];
}

- (void) loginSuccessful {
    NSLog(@"33isBangDing = %d", isBangding);
    if (isBangding) {
        NSLog(@"跳转首页");
        if (isSettingPsd == YES) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            NSLog(@"请绑定手机");
            WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
            wxloginVC.userInfo = dic;
            [self.navigationController pushViewController:wxloginVC animated:YES];
        }
    } else {
        NSLog(@"请绑定手机");
        WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
        wxloginVC.userInfo = dic;
        [self.navigationController pushViewController:wxloginVC animated:YES];
    }
}



- (NSArray *)randomArray{
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:62];
    
    for (int i = 0; i<10; i++) {
        // NSLog(@"%d", i);
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [mutable addObject:string];
    }
    for (char i = 'a'; i<='z'; i++) {
        // NSLog(@"%c", i);
        NSString *string = [NSString stringWithFormat:@"%c", i];
        
        [mutable addObject:string];
    }
    NSArray *array = [NSArray arrayWithArray:mutable];
    return array;
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
                  [self alertMessage:@"用户名或密码错误!"];
              }
              if ([[responseObject objectForKey:@"result"] isEqualToString:@"p_error"]) {
                  [self alertMessage:@"用户名或密码错误!"];
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
                  
                  
//                  NSDictionary *params = [[NSUserDefaults standardUserDefaults]objectForKey:@"MiPush"];
//                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                  
//                  
//                  
//                  NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
//                  
//             
//                  
//                  NSLog(@"urlStr = %@", urlString);
//                  NSLog(@"params = %@", params);
//
//                  [manager POST:urlString parameters:params
//                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                            //  NSError *error;
//                            NSLog(@"JSON: %@", responseObject);
//                            NSString *user_account = [responseObject objectForKey:@"user_account"];
//                            NSLog(@"user_account = %@", user_account);
//                            if ([user_account isEqualToString:@""]) {
//                                
//                            } else {
//                                [MiPushSDK setAccount:user_account];
//                            }
//                            
//                            
//                        }
//                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"Error: %@", error);
//                            
//                            
//                        }];

                  
                  
                  [self.navigationController popViewControllerAnimated:NO];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              
          }];
}

-(void) alertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)forgetPasswordClicked:(UIButton *)sender {
    NSLog(@"忘记密码");
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"请验证手机",@"isRegister":@NO,@"isMessageLogin":@NO};
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (IBAction)registerClicked:(UIButton *)sender {
    //登录界面进入手机注册界面
    NSLog(@"注册");
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    
    verifyVC.config = @{@"title":@"手机注册",@"isRegister":@YES, @"isMessageLogin":@NO};
    
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (IBAction)verifyMessageClicked:(id)sender {
    
    NSLog(@"短信验证");
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"短信验证码登录",@"isRegister":@YES,@"isMessageLogin":@YES};
    [self.navigationController pushViewController:verifyVC animated:YES];
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
    
    if ([WXApi isWXAppInstalled]) {
        
    } else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        
        return;
    }
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"xiaolumeimei" ;
    NSLog(@"req = %@", req);
    [WXApi sendReq:req];
}
@end
