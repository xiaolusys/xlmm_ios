//
//  JMPhonenumViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPhonenumViewController.h"
#import "WXApi.h"
#import "MiPushSDK.h"
#import "JMLineView.h"
#import "JMLogInViewController.h"
#import "JMVerificationCodeController.h"
#import "AESEncryption.h"
#import "JMRootTabBarController.h"
#import "AppDelegate.h"
#import "WebViewController.h"


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


@property (nonatomic, strong) UIButton *registeredButton;



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
    self.rememberPwdBtn.selected = [JMUserDefaults boolForKey:rememberPwdKey];
    
    //设置账号和密码的默认值
    self.phoneNumTextF.text = [JMUserDefaults objectForKey:kUserName];
    if (self.rememberPwdBtn.selected) {
        NSString *decryptedStr = [AESEncryption decrypt:[JMUserDefaults objectForKey:kPassWord] password:self.phoneNumTextF.text];
        self.passwordTextF.text = decryptedStr;
    }
    
//    [self textChange];
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
    
    self.registeredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.registeredButton];
    //设置按钮文字的下划线
    NSMutableAttributedString *muTitle = [[NSMutableAttributedString alloc] initWithString:@"如何注册成为小鹿妈妈"];
    NSRange titleRange2 = {0,[muTitle length]};
    [self.registeredButton setTitle:@"如何注册成为小鹿妈妈" forState:UIControlStateNormal];
    [muTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange2];
    [self.registeredButton setAttributedTitle:muTitle forState:UIControlStateNormal];
    [self.registeredButton.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    self.registeredButton.titleLabel.textColor = [UIColor redColor];
    [self.registeredButton addTarget:self action:@selector(registeredButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark --- 记住密码按钮的点击
- (void)remenberClick:(UIButton *)sender {
    self.rememberPwdBtn.selected = !self.rememberPwdBtn.selected;
    [JMUserDefaults setBool:self.rememberPwdBtn.selected forKey:rememberPwdKey];
    [JMUserDefaults synchronize];
}

#pragma mark ------ 登录按钮点击
- (void)loginBtnClick:(UIButton *)btn {
    // ....
    if ([NSString isStringEmpty:self.phoneNumTextF.text]) {
        [MBProgressHUD showMessage:@"请输入手机号!"];
        return ;
    }else {
        if (self.phoneNumTextF.text.length != 11  || ![NSString isStringWithNumber:self.phoneNumTextF.text]) {
            [MBProgressHUD showMessage:@"请检查手机号!"];
            return ;
        }
    }
    if ([NSString isStringEmpty:self.passwordTextF.text]) {
        [MBProgressHUD showMessage:@"请输入密码!"];
        return ;
    }else {
        
    }
    btn.enabled = NO;
    [self.phoneNumTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    NSString *userName = _phoneNumTextF.text;
    NSString *password = _passwordTextF.text;
    if (userName.length == 0 || password.length == 0) {
        [MBProgressHUD showWarning:@"请输入正确的信息！"];
        return;
    }
    [MBProgressHUD showLoading:@"登录中....."];
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password,
                                 @"devtype":LOGINDEVTYPE};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TPasswordLogin_URL WithParaments:parameters WithSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) {
            //            [self alertMessage:[responseObject objectForKey:@"msg"]];
            //            [SVProgressHUD dismiss];
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"]];
            btn.enabled = YES;
            return ;
        }
        // 手机登录成功 ，保存用户信息以及登录途径
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogin];
        [JMUserDefaults setObject:Root_URL forKey:@"serverip"];
        NSString *encryptionStr = [AESEncryption encrypt:self.passwordTextF.text password:self.phoneNumTextF.text];
        [JMUserDefaults setObject:self.phoneNumTextF.text forKey:kUserName];
        [JMUserDefaults setObject:encryptionStr forKey:kPassWord];
        [JMUserDefaults setObject:kPhoneLogin forKey:kLoginMethod];
        [JMUserDefaults synchronize];
        [self loadUserInfo];
        [self setDevice];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"登录失败，请重试"];
        btn.enabled = YES;
    } Progress:^(float progress) {
    }];
}
#pragma mark ---- 登录成功后获取用户信息
- (void)loadUserInfo {
    /*
     1. 用户绑定手机, 且是精英妈妈.  ---> 跳转到主页
     2. 用户绑定手机, 但不是精英妈妈. ---> 提示此用户权限不够.
     3. 用户没用绑定手机, 但是是精英妈妈. ---> 跳转到绑定手机.
     4. 用户没有绑定手机, 且不是精英妈妈. ---> 提示用户需要注册成为会员
     */
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        BOOL kIsLoginStatus = ([responseObject objectForKey:@"id"] != nil)  && ([[responseObject objectForKey:@"id"] integerValue] != 0);
        BOOL kIsXLMMStatus = [[responseObject objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
        BOOL kIsBindPhone = [NSString isStringEmpty:[responseObject objectForKey:@"mobile"]];
        BOOL kIsVIP = NO;
        if (kIsXLMMStatus) {
            NSDictionary *xlmmDict = responseObject[@"xiaolumm"];
            kIsVIP = [xlmmDict[@"last_renew_type"] integerValue] >= 90 ? YES : NO;
        }
        [JMUserDefaults setBool:kIsLoginStatus forKey:kIsLogin];
        [JMUserDefaults setBool:kIsXLMMStatus forKey:kISXLMM];
        [JMUserDefaults synchronize];
        if (kIsVIP) {
            if (!kIsBindPhone) {
                // 跳主页
                // 发送手机号码登录成功的通知
                [JMNotificationCenter postNotificationName:@"phoneNumberLogin" object:nil];
                [self backApointInterface];
            }else {
                // 绑定手机
                NSDictionary *weChatInfo = [JMUserDefaults objectForKey:kWxLoginUserInfo];
                JMVerificationCodeController *vc = [[JMVerificationCodeController alloc] init];
                vc.verificationCodeType = SMSVerificationCodeWithBind;
                vc.userInfo = weChatInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else {
            JMVerificationCodeController *vc = [[JMVerificationCodeController alloc] init];
            vc.verificationCodeType = SMSVerificationCodeWithLogin;
            vc.userNotXLMM = YES;
            vc.profileUserInfo = responseObject;
            [self.navigationController pushViewController:vc animated:YES];
            // 提示
            //            [MBProgressHUD showMessage:@"您还不是精英妈妈"];
        }
        self.loginBtn.enabled = YES;
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (response) {
            if (response.statusCode) {
                NSInteger statusCode = response.statusCode;
                if (statusCode == 403) {
                    NSLog(@"%ld",statusCode);
                    [JMUserDefaults removeObjectForKey:kIsLogin];
                    [JMUserDefaults removeObjectForKey:kISXLMM];
                }
            }
        }
        [JMUserDefaults synchronize];
        self.loginBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"登录失败，请重试"];
    } Progress:^(float progress) {
    }];
}
- (void)setDevice{
    NSDictionary *params = [JMUserDefaults objectForKey:@"MiPush"];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
    
    NSLog(@"urlStr = %@", urlString);
    NSLog(@"params = %@", params);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *user_account = [responseObject objectForKey:@"user_account"];
        NSLog(@"user_account = %@", user_account);
        if ([user_account isEqualToString:@""]) {
            
        } else {
            [MiPushSDK setAccount:user_account];
            //保存user_account
            [JMUserDefaults setObject:user_account forKey:@"user_account"];
            [JMUserDefaults synchronize];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];

}



#pragma mark ---- 忘记密码按钮点击
- (void)forgetPasswordClicked:(UIButton *)sender {
    JMVerificationCodeController *verifyVC = [[JMVerificationCodeController alloc] init];
    verifyVC.verificationCodeType = SMSVerificationCodeWithForgetPWD;
    verifyVC.userLoginMethodWithWechat = YES;
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}
//点击键盘的返回键  执行这个方法  -- 用来隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneNumTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.phoneNumTextF) {
        self.passwordTextF.text = @"";
    }
    return YES;
}
-(void) alertMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark --- 视图显示或者消失时一些属性的状态
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
    
    CGFloat registW = [@"如何注册成为小鹿妈妈" widthWithHeight:20. andFont:13.].width + 20;
    [self.registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.loginBtn.mas_centerX);
        make.width.mas_equalTo(@(registW));
    }];
    
    
}

- (void)btnClickedLogin:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMPhonenumViewController"];
    self.loginBtn.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMPhonenumViewController"];
}

- (void)backApointInterface {
    [MBProgressHUD hideHUD];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)registeredButtonClicked {
    NSString *urlString = @"https://m.xiaolumeimei.com/mall/boutiqueinvite";
    NSString *active = @"myInvite";
    NSString *titleName = @"我的邀请";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@38 forKey:@"activity_id"];
    [dict setValue:urlString forKey:@"web_url"];
    [dict setValue:active forKey:@"type_title"];
    [dict setValue:titleName forKey:@"name_title"];
    [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:YES Title:nil];
    
}
- (void)pushWebView:(NSMutableDictionary *)dict ShowNavBar:(BOOL)isShowNavBar ShowRightShareBar:(BOOL)isShowRightShareBar Title:(NSString *)title {
    WebViewController *activity = [[WebViewController alloc] init];
    if (title != nil) {
        activity.titleName = title;
    }
    activity.webDiction = dict;
    activity.isShowNavBar = isShowNavBar;
    activity.isShowRightShareBtn = isShowRightShareBar;
    [self.navigationController pushViewController:activity animated:YES];
}



@end





































