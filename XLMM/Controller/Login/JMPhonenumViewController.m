//
//  JMPhonenumViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPhonenumViewController.h"
#import "MMClass.h"
#import "WXApi.h"
#import "MiPushSDK.h"
#import "VerifyPhoneViewController.h"
#import "JMLineView.h"
#import "MMRootViewController.h"
#import "JMLogInViewController.h"

#define rememberPwdKey @"rememberPwd"

@interface JMPhonenumViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) JMLineView *lineView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UITextField *phoneNumTextF;

@property (nonatomic,strong) UITextField *passwordTextF;

//是否可以查看密码的按钮
@property (nonatomic,strong) UIButton *isSeePwdBtn;

@property (nonatomic,strong) UIButton *rememberPwdBtn;

@property (nonatomic,strong) UIButton *forgetPwdBtn;


@property (nonatomic,strong) UIView *forgetPwdBottomView;


@property (nonatomic,strong) UIButton *loginBtn;






@end

@implementation JMPhonenumViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    JMLineView *lineView = [[JMLineView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.frame  = self.view.frame;
    self.lineView = lineView;
    [self.view addSubview:lineView];
    [lineView setNeedsDisplay];
    
    
    [self createNavigationBarWithTitle:@"手机号登录" selecotr:@selector(btnClickedLogin:)];
    
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
    
//    [self textChange];
    
    //设置记住密码按钮默认值
    NSUserDefaults *defaultsPwd = [NSUserDefaults standardUserDefaults];
    self.rememberPwdBtn.selected = [defaultsPwd boolForKey:@"rememberPwd"];
    
    
}



- (void)prepareUI {
    
    UIView *bottomView = [UIView new];
    [self.lineView addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor lineGrayColor];
    
    /**
     文本框控件
     */
    UITextField *phoneNumTextF  = [[UITextField alloc] init];
    [self.lineView addSubview:phoneNumTextF];
    self.phoneNumTextF = phoneNumTextF;
    self.phoneNumTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextF.font = [UIFont systemFontOfSize:14.];
    self.phoneNumTextF.placeholder = @"请输入手机号";
    self.phoneNumTextF.delegate = self;
    
    UITextField *passwordTextF = [UITextField new];
    [self.lineView addSubview:passwordTextF];
    self.passwordTextF = passwordTextF;
    self.passwordTextF.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextF.font = [UIFont systemFontOfSize:14.];
    self.passwordTextF.placeholder = @"请输入登录密码";
    self.passwordTextF.delegate = self;
    self.passwordTextF.secureTextEntry = YES;

    
    /**
     按钮控件
     */
    UIButton *isSeePwdBtn  = [UIButton new];
    [self.lineView addSubview:isSeePwdBtn];
    self.isSeePwdBtn = isSeePwdBtn;
    [isSeePwdBtn setImage:[UIImage imageNamed:@"hide_passwd_icon"] forState:UIControlStateNormal];
    [isSeePwdBtn addTarget:self action:@selector(seePasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rememberPwdBtn = [UIButton new];
    [self.bottomView addSubview:rememberPwdBtn];
    self.rememberPwdBtn = rememberPwdBtn;
    [rememberPwdBtn setAdjustsImageWhenHighlighted:NO];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"remember_password"] forState:UIControlStateSelected];
    [rememberPwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [rememberPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rememberPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13.];
    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//调整图片文字间距
    [rememberPwdBtn addTarget:self action:@selector(remenberClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    forgetPwdBtn.titleLabel.textColor = [UIColor colorWithRed:86/255. green:195/255. blue:241/255. alpha:1.];
    [forgetPwdBtn addTarget:self action:@selector(forgetPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *loginBtn = [UIButton new];
    [self.bottomView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --- 记住密码按钮的点击
- (void)remenberClick:(UIButton *)sender {
    
    if (self.rememberPwdBtn.selected) {
        self.rememberPwdBtn.selected = NO;
    }else {
        self.rememberPwdBtn.selected = YES;
    }
    
    NSUserDefaults *defaultsPwd = [NSUserDefaults standardUserDefaults];
    [defaultsPwd setBool:self.rememberPwdBtn.selected forKey:@"rememberPwd"];
    [defaultsPwd synchronize];
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
        [SVProgressHUD showInfoWithStatus:@"请输入正确的信息！"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password,
                                 @"devtype":LOGINDEVTYPE};
    
    [manager POST:TPasswordLogin_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) {
//            [self alertMessage:[responseObject objectForKey:@"msg"]];
//            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            return ;
        }
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // 手机登录成功 ，保存用户信息以及登录途径
        [defaults setBool:YES forKey:kIsLogin];
        [defaults setObject:Root_URL forKey:@"serverip"];
        
        NSDictionary *userInfo = @{kUserName:self.phoneNumTextF.text,
                                   kPassWord:self.passwordTextF.text};
        [defaults setObject:userInfo forKey:kPhoneNumberUserInfo];
        [defaults setObject:kPhoneLogin forKey:kLoginMethod];
        [defaults synchronize];
        
        [SVProgressHUD showInfoWithStatus:@"登录中....."];

        
        // 发送手机号码登录成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
        
        [self setDevice];
       
        
        [self backApointInterface];
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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



#pragma mark ---- 忘记密码按钮点击

- (void)forgetPasswordClicked:(UIButton *)sender {
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"请验证手机",@"isRegister":@NO,@"isMessageLogin":@NO,@"isVerifyPsd":@YES};
    [self.navigationController pushViewController:verifyVC animated:YES];
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
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
//点击键盘的返回键  执行这个方法  -- 用来隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    
}
//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    self.loginBtn.enabled = (self.phoneNumTextF.text.length != 0 && self.passwordTextF.text.length != 0);
    return YES;
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.loginBtn.enabled = NO;
    
    return YES;
}


-(void) alertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark --- 视图显示或者消失时一些属性的状态

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_phoneNumTextF.text forKey:kUserName];
    [userDefaults setObject:_passwordTextF.text forKey:kPassWord];
    [userDefaults synchronize];
}


- (void)prepareInitUI {
    
    kWeakSelf
    
    [self.phoneNumTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView).offset(64);
        make.left.equalTo(weakSelf.lineView).offset(15);
        make.right.equalTo(weakSelf.lineView).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    [self.passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom);
        make.left.equalTo(weakSelf.lineView).offset(15);
        make.right.equalTo(weakSelf.isSeePwdBtn.mas_left).offset(-15);
        make.height.mas_equalTo(60);
    }];
    //密码是否可见的按钮
    [self.isSeePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.lineView).offset(-10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordTextF.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.lineView);
    }];
    
    [self.rememberPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(10);
        make.left.equalTo(weakSelf.bottomView).offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@100);
    }];
    
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(10);
        make.right.equalTo(weakSelf.bottomView).offset(-10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(60);
        make.centerX.equalTo(weakSelf.bottomView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@43);
    }];
    
    
    
}

- (void)btnClickedLogin:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMPhonenumViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"JMPhonenumViewController"];
}

- (void)backApointInterface {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end





































