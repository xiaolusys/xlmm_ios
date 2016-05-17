//
//  JMPhonenumViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPhonenumViewController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "MiPushSDK.h"
#import "VerifyPhoneViewController.h"



#define rememberPwdKey @"rememberPwd"

@interface JMPhonenumViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *bottomView;


@property (nonatomic,strong) UITextField *phoneNumTextF;

@property (nonatomic,strong) UITextField *passwordTextF;

@property (nonatomic,strong) UIView *centerLineView;

//是否可以查看密码的按钮
@property (nonatomic,strong) UIButton *isSeePwdBtn;


@property (nonatomic,strong) UIButton *rememberPwdBtn;

@property (nonatomic,strong) UIButton *forgetPwdBtn;


@property (nonatomic,strong) UIView *forgetPwdBottomView;


@property (nonatomic,strong) UIButton *loginBtn;






@end

@implementation JMPhonenumViewController


- (void)viewDidLoad {
    
    [self createNavigationBarWithTitle:@"手机号登录" selecotr:@selector(btnClicked:)];
    
    [self prepareUI];
    [self prepareInitUI];
    
    //设置记住密码的默认值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rememberPwdBtn.selected = [defaults boolForKey:rememberPwdKey];
    
    //设置账号和密码的默认值
    self.phoneNumTextF.text = [defaults objectForKey:kUserName];
    if (self.rememberPwdBtn.selected) {
        self.passwordTextF.text = [defaults objectForKey:kPassWord];
    }
    
    [self textChange];
    
}



- (void)prepareUI {
    
    /**
     底部视图控件
     */
    UIView *headView  = [[UIView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    /**
     分割线 控件
     
     - returns:
     */
    UIView *centerLineView  = [[UIView alloc] init];
    [self.headView addSubview:centerLineView];
    self.centerLineView = centerLineView;
    
    
    //    UIView *forgetPwdBottomView = [UIView new];
    //    [self.bottomView addSubview:forgetPwdBottomView];
    //    self.forgetPwdBottomView = forgetPwdBottomView;
    
    /**
     文本框控件
     */
    UITextField *phoneNumTextF  = [[UITextField alloc] init];
    [self.headView addSubview:phoneNumTextF];
    self.phoneNumTextF = phoneNumTextF;
    self.phoneNumTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextF.font = [UIFont systemFontOfSize:14.];
    self.phoneNumTextF.placeholder = @"手机号";
    self.phoneNumTextF.delegate = self;
    
    
    UITextField *passwordTextF = [UITextField new];
    [self.headView addSubview:passwordTextF];
    self.passwordTextF = passwordTextF;
    self.passwordTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextF.font = [UIFont systemFontOfSize:14.];
    self.passwordTextF.placeholder = @"手机号";
    self.passwordTextF.delegate = self;
    
    
    /**
     按钮控件
     */
    UIButton *isSeePwdBtn  = [[UIButton alloc] init];
    [self.headView addSubview:isSeePwdBtn];
    self.isSeePwdBtn = isSeePwdBtn;
    [isSeePwdBtn addTarget:self action:@selector(seePasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rememberPwdBtn = [UIButton new];
    [self.bottomView addSubview:rememberPwdBtn];
    self.rememberPwdBtn = rememberPwdBtn;
    
    UIButton *forgetPwdBtn  = [[UIButton alloc] init];
    [self.bottomView addSubview:forgetPwdBtn];
    self.forgetPwdBtn = forgetPwdBtn;
    //设置按钮文字的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange titleRange = {0,[title length]};
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [forgetPwdBtn setAttributedTitle:title forState:UIControlStateNormal];
    [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    [forgetPwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginBtn = [UIButton new];
    [self.bottomView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark ----- 保存记住密码按钮的数据到用户偏好设置
- (void)saveRememberPwdBtn {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.rememberPwdBtn.selected forKey:rememberPwdKey];
    [defaults synchronize];
}

#pragma mark ------ 登录按钮点击
- (void)loginBtnClick:(UIButton *)btn {
    
    NSString *userName = _phoneNumTextF.text;
    NSString *password = _passwordTextF.text;
    if (userName.length == 0 || password.length == 0) {
        [self alertMessage:@"用户名或者密码为空呢"];
        return;
    }
    
    [SVProgressHUD showErrorWithStatus:@"登录中....."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password,
                                 @"devtype":LOGINDEVTYPE};
    
    [manager POST:TPasswordLogin_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) {
            [self alertMessage:[responseObject objectForKey:@"msg"]];
            return ;
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // 手机登录成功 ，保存用户信息以及登录途径
        [defaults setBool:YES forKey:kIsLogin];
        [defaults setObject:Root_URL forKey:@"serverip"];
        
        NSDictionary *userInfo = @{kUserName:self.phoneNumTextF.text,
                                   kPassWord:self.passwordTextF.text};
        [defaults setObject:userInfo forKey:kPhoneNumberUserInfo];
        
        //        [defaults setObject:kUserName forKey:userName];
        //        if (self.rememberPwdBtn.selected == YES) {
        //            [defaults setObject:kPassWord forKey:password];
        //        }
        
        [defaults setObject:kPhoneLogin forKey:kLoginMethod];
        [defaults synchronize];
        
        // 发送手机号码登录成功的通知
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
        
        [self setDevice];
        [self.navigationController popViewControllerAnimated:NO];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
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



#pragma mark ---- 忘记密码按钮点击

- (void)forgetPasswordClicked:(UIButton *)sender {
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"请验证手机",@"isRegister":@NO,@"isMessageLogin":@NO,@"isVerifyPsd":@YES};
    [self.navigationController pushViewController:verifyVC animated:YES];
}






- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- 监听文本输入框变化
-(void)textChange{
    
    self.loginBtn.enabled = (self.phoneNumTextF.text.length != 0 && self.passwordTextF.text.length != 0);
    //没有值，禁用登录按钮
}

#pragma mark ----- 是否显示密码明文或者暗文
- (void)seePasswordButtonClicked:(UIButton *)sender {
    UIImage *image = nil;
    if (self.passwordTextF.secureTextEntry) {
        image = [UIImage imageNamed:@"display_passwd_icon.png"];
    } else {
        image = [UIImage imageNamed:@"hide_passwd_icon.png"];
    }
    [self.isSeePwdBtn setImage:image forState:UIControlStateNormal];
    self.passwordTextF.secureTextEntry = !self.passwordTextF.secureTextEntry;
}

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
    [self.phoneNumTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    
}

-(void) alertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark --- 视图显示或者消失时一些属性的状态
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_phoneNumTextF.text forKey:kUserName];
    [userDefaults setObject:_passwordTextF.text forKey:kPassWord];
    [userDefaults synchronize];
}


- (void)prepareInitUI {
    
    kWeakSelf
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(121);
    }];
    
    [self.phoneNumTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom);
        make.left.right.equalTo(weakSelf.headView);
        make.height.mas_equalTo(1);
    }];
    
    [self.passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLineView);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.right.equalTo(weakSelf.isSeePwdBtn).offset(-10);
        make.height.mas_equalTo(60);
    }];
    //密码是否可见的按钮  大小先固定为40 * 40
    [self.isSeePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLineView.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.width.height.mas_equalTo(@40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [self.rememberPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(10);
        make.left.equalTo(weakSelf.bottomView).offset(10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
    }];
    
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(10);
        make.right.equalTo(weakSelf.bottomView).offset(-10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
    }];
    
    //    [self.forgetPwdBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.forgetPwdBtn).offset(1);
    //        make.right.equalTo(weakSelf.bottomView).offset(-10);
    //        make.height.mas_equalTo(@30);
    //        make.width.mas_equalTo(@80);
    //    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rememberPwdBtn.mas_bottom).offset(30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.left.equalTo(weakSelf.view).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
        make.height.mas_equalTo(@40);
    }];
    
    
    
}


@end





































