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
#import "MobClick.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

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
//    _passwordTextField.text = [userDefault objectForKey:kPassWord];
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
    int index = 0;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    __unused long time = [timeSp integerValue];
    NSLog(@"time = %ld", (long)time);
    randomstring = [[NSMutableString alloc] initWithCapacity:0];
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
    
    NSLog(@"sign = %@", sign);
    
    
    //http://m.xiaolu.so/rest/v1/register/wxapp_login
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/weixinapplogin?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    
    NSDictionary *newDic = @{@"headimgurl":[dic objectForKey:@"headimgurl"],
                             @"nickname":[dic objectForKey:@"nickname"],
                             @"openid":[dic objectForKey:@"openid"],
                             @"unionid":[dic objectForKey:@"unionid"],
                             @"devtype":LOGINDEVTYPE};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:newDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if (result.count == 0) return;
        if ([[result objectForKey:@"rcode"]integerValue] != 0) {
            [self alertMessage:[result objectForKey:@"msg"]];
            return;
        }
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"login"];
        [userdefaults synchronize];
        [self loginSuccessful];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void) loginSuccessful {
    [MobClick profileSignInWithPUID:@"playerID"];
    
    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"weixinlogin" object:self];
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter postNotification: broadcastMessage];
    
    [self setDevice];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

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
    
    NSLog(@"array = %@", array);
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
    NSString *userName = _userIDTextField.text;
    NSString *password = _passwordTextField.text;
    if (userName.length == 0 || password.length == 0) {
        [self alertMessage:@"用户名或者密码为空呢"];
        return;
    }
    
    [SVProgressHUD showInfoWithStatus:@"登录中....."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password,
                                 @"devtype":LOGINDEVTYPE};

    [manager POST:TPasswordLogin_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [SVProgressHUD dismiss];
              
              if ([[responseObject objectForKey:@"rcode"] integerValue] != 0){
                  [self alertMessage:[responseObject objectForKey:@"msg"]];
                  return ;
              }
              
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              // 手机登录成功 ，保存用户信息以及登录途径
              [defaults setBool:YES forKey:kIsLogin];
              [defaults setObject:Root_URL forKey:@"serverip"];
              
              NSDictionary *userInfo = @{kUserName:self.userIDTextField.text,
                                         kPassWord:self.passwordTextField.text};
              [defaults setObject:userInfo forKey:kPhoneNumberUserInfo];
              
              [defaults setObject:kPhoneLogin forKey:kLoginMethod];
              [defaults synchronize];
              // 发送手机号码登录成功的通知
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
              
              [self setDevice];
              [self.navigationController popViewControllerAnimated:NO];
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              //[SVProgressHUD dismiss];
              [SVProgressHUD showErrorWithStatus:@"登录失败，请重试"];
          }];
}

- (void)setDevice{
    NSDictionary *params = [[NSUserDefaults standardUserDefaults]objectForKey:@"MiPush"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];

    NSLog(@"urlStr = %@", urlString);
    NSLog(@"params = %@", params);
    
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
              NSLog(@"JSON: %@", responseObject);
              NSString *user_account = [responseObject objectForKey:@"user_account"];
              NSLog(@"user_account = %@", user_account);
              if ([user_account isEqualToString:@""]) {
                  
              } else {
                  [MiPushSDK setAccount:user_account];
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
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"请验证手机",@"isRegister":@NO,@"isMessageLogin":@NO,@"isVerifyPsd":@YES};
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (IBAction)registerClicked:(UIButton *)sender {
    //登录界面进入手机注册界面
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    
    verifyVC.config = @{@"title":@"手机注册",@"isRegister":@YES, @"isMessageLogin":@NO};
    
    [self.navigationController pushViewController:verifyVC animated:YES];
}




- (IBAction)verifyMessageClicked:(id)sender {
    
//    NSLog(@"短信验证");
    
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
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"wxlogin" forKey:kWeiXinauthorize];
    [userdefaults synchronize];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"xiaolumeimei" ;
    NSLog(@"req = %@", req);
    [WXApi sendReq:req];
}
@end
