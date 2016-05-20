//
//  JMAuthcodeViewController.m
//  XLMM
//
//  Created by zhang on 16/5/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAuthcodeViewController.h"
#import "JMAuthcodeViewController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"
#import "JMLineView.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"


#define PHONE_NUM_LIMIT 11
#define VERIFY_CODE_LIMIT 6
#define COUNTING_LIMIT 60



@interface JMAuthcodeViewController ()<UITextFieldDelegate> {
    //    NSUInteger secondsCountDown;
}

@property (nonatomic,strong) JMLineView *lineView;

@property (nonatomic,strong) JMSelecterButton *selButton;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UITextField *phoneNumTextF;

@property (nonatomic,strong) UITextField *authcodeTextF;

//是否可以查看密码的按钮
@property (nonatomic,strong) UIButton *getAuthcodeBtn;

@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation JMAuthcodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    JMLineView *lineView = [[JMLineView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.frame  = self.view.frame;
    self.lineView = lineView;
    [self.view addSubview:lineView];
    [lineView setNeedsDisplay];
    
    [self createNavigationBarWithTitle:@"短信验证登录" selecotr:@selector(btnClickedLogin:)];
    [self prepareUI];
    [self prepareInitUI];

}

#pragma mark ------ 初始化UI
- (void)prepareUI {
    
    
    UIView *bottomView = [UIView new];
    [self.lineView addSubview:bottomView];
    self.bottomView = bottomView;
    
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
    self.phoneNumTextF.placeholder = @"请输入注册手机号";
    self.phoneNumTextF.delegate = self;
//    [self.phoneNumTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    
    
    UITextField *authcodeTextF = [UITextField new];
    [self.lineView addSubview:authcodeTextF];
    self.authcodeTextF = authcodeTextF;
    self.authcodeTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.authcodeTextF.leftViewMode = UITextFieldViewModeAlways;
    self.authcodeTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.authcodeTextF.font = [UIFont systemFontOfSize:14.];
    self.authcodeTextF.placeholder = @"请输入短信验证码";
    self.authcodeTextF.delegate = self;
//    [self.authcodeTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    /**
     按钮控件
     */
    self.selButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.lineView addSubview:self.selButton];
    [_selButton setNomalBorderColor:[UIColor buttonDisabledBorderColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"获取验证码" TitleFont:13. CornerRadius:15.];
    self.selButton.selected = NO;
    self.selButton.enabled = NO;
    [_selButton addTarget:self action:@selector(getAuthcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *loginBtn = [UIButton new];
    [self.bottomView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(void)textChange{
//    
//    self.loginBtn.enabled = (self.phoneNumTextF.text.length != 0 && self.authcodeTextF.text.length != 0);
//    //没有值，禁用登录按钮
//}
#pragma mark ---- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@" "]) {
        return NO;
    }
    BOOL increase = NO;
    if (textField.text.length == range.location) {
        increase = YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    
    if (self.authcodeTextF == textField) {
        
        if (increase && range.location >= VERIFY_CODE_LIMIT - 1 && self.loginBtn.enabled == NO) {
            self.loginBtn.enabled = YES;
        }else {}
        
        if (!increase && range.location <= VERIFY_CODE_LIMIT - 1 && self.loginBtn.enabled == YES) {
            self.loginBtn.enabled = NO;
        }else {}
        
        if ([toBeString length] > VERIFY_CODE_LIMIT) {
            textField.text = [toBeString substringToIndex:VERIFY_CODE_LIMIT];
            return NO;
        }else {}
    }else {}
    
    if (self.phoneNumTextF == textField) {
        
        if (increase && range.location >= PHONE_NUM_LIMIT - 1 && self.selButton.enabled == NO) {
            self.selButton.selected = YES;
            self.selButton.enabled = YES;
        }else {}
        
        if (!increase && range.location <= PHONE_NUM_LIMIT - 1 && self.selButton.enabled == YES) {
            self.selButton.selected = NO;
            self.selButton.enabled = NO;
        }else {}
        
        if ([toBeString length] > PHONE_NUM_LIMIT) {
            textField.text = [toBeString substringToIndex:PHONE_NUM_LIMIT];
            self.selButton.selected = YES;
            return NO;
        }else {}
    }else {
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTextF resignFirstResponder];
    [self.authcodeTextF resignFirstResponder];
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.phoneNumTextF) {
        self.selButton.enabled = NO;
        self.selButton.selected = NO;
    }
    if (textField == self.authcodeTextF) {
        self.loginBtn.enabled = NO;
    }
    
    return YES;
}





#pragma mark ---- 点击获取验证码按钮
- (void)getAuthcodeClick:(UIButton *)sender {
    NSString *phoneNumber = self.phoneNumTextF.text;

    NSInteger num  = [[phoneNumber substringToIndex:1] integerValue];
    if (num == 1 && phoneNumber.length == 11) { 
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameters = nil;
        NSString *stringurl = TSendCode_URL;;
        
        
//        parameters = self.config;
        
//        if ([self.config[@"isRegister"] boolValue] == YES && [self.config[@"isMessageLogin"] boolValue] == NO){
//            //手机注册
//            parameters = @{@"mobile": phoneNumber, @"action":@"register"};
//        }else if ([self.config[@"isUpdateMobile"] boolValue] == YES){
//            //修改密码
//            parameters = @{@"mobile": phoneNumber, @"action":@"change_pwd"};
//        }else if ([self.config[@"isMessageLogin"] boolValue] ==   YES){
//            //短信登录
//            parameters = @{@"mobile": phoneNumber, @"action":@"sms_login"};
//        }else if ([self.config[@"isVerifyPsd"] boolValue] == YES) {
//            //忘记密码
//            parameters = @{@"mobile": phoneNumber, @"action":@"find_pwd"};
//        }
//authL.config = @{@"title":@"短信验证码登录",@"isRegister":@YES,@"isMessageLogin":@YES};
        
        if ([self.config[@"isRegister"] boolValue] == YES && [self.config[@"isMessageLogin"] boolValue] == YES) {
            parameters = @{@"mobile": phoneNumber, @"action":@"sms_login"};
        }
        
        [manager POST:stringurl parameters:parameters
         
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSInteger rcodeStr = [[responseObject objectForKey:@"rcode"] integerValue];
                  
                  if (rcodeStr == 0) {
                      
                      [self startTime];
                      
                  }else {
                      [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                  }
                  
              }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  [SVProgressHUD showErrorWithStatus:@"获取失败！"];
                  
              }];
    
    }else {
        [SVProgressHUD showErrorWithStatus:@"手机号错误！"];
    }
    
    
}
#pragma mrak ----- 创建一个定时器
- (void)startTime {
    __block int secondsCountDown = COUNTING_LIMIT;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    
    dispatch_source_set_event_handler(_timer, ^{
        if(secondsCountDown<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_selButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _selButton.enabled = NO;
                _selButton.selected = YES;
            });
        }else{
            int seconds = secondsCountDown % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_selButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _selButton.enabled = NO;
                _selButton.selected = NO;
            });
            secondsCountDown--;
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark ---- 登录按钮点击 --> 检验验证码是否正确
- (void)loginBtnClick:(UIButton *)sender {
    NSString *phoneNumber = self.phoneNumTextF.text;
    NSString *vcode = self.authcodeTextF.text;
    
    NSDictionary *parameters = nil;
    
    [SVProgressHUD showWithStatus:@"登录中....."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([self.config[@"isMessageLogin"] boolValue]) {
        parameters = @{@"mobile":phoneNumber,@"action":@"sms_login", @"verify_code":vcode, @"devtype":LOGINDEVTYPE};
    }
    
//    else if ([self.config[@"isRegister"] boolValue]){
//        parameters = @{@"mobile":phoneNumber, @"action":@"register", @"verify_code":vcode,  @"devtype":LOGINDEVTYPE};
//    }else if ([self.config[@"isVerifyPsd"] boolValue]){
//        parameters = @{@"mobile":phoneNumber, @"action":@"find_pwd", @"verify_code":vcode};
//    }else if ([self.config[@"isUpdateMobile"] boolValue]) {
//        parameters = @{@"mobile":phoneNumber, @"action":@"change_pwd", @"verify_code":vcode};
//    }
    
    
    [manager POST:TVerifyCode_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self verifyAfter:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"登录失败！"];
        
    }];
    
    
    
}
- (void)verifyAfter:(NSDictionary *)dic {
    if (dic.count == 0)return;
    NSString *phoneNumber = self.phoneNumTextF.text;
    
    if ([[dic objectForKey:@"rcode"] integerValue] != 0){
        
//        [SVProgressHUD dismiss];
//        [self alertMessage:[dic objectForKey:@"msg"]];
        
        return;
    }
    if ([self.config[@"isRegister"] boolValue] || [self.config[@"isMessageLogin"] boolValue]) {
//        [self alertMessage:[dic objectForKey:@"msg"]];
        //设置用户名在newLeft中使用
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:phoneNumber forKey:kUserName];
        [user setBool:YES forKey:kIsLogin];
        //发送通知在root中接收
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
        
        NSInteger count = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.config[@"isVerifyPsd"] boolValue] || [self.config[@"isUpdateMobile"] boolValue]) {
        //        [self displaySetPasswordPage];
    }
}
#pragma mark ---- 控件显示
- (void)prepareInitUI {
    
    kWeakSelf
    
    [self.phoneNumTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView).offset(64);
        make.left.equalTo(weakSelf.lineView).offset(15);
        make.right.equalTo(weakSelf.lineView).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    [self.authcodeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom);
        make.left.equalTo(weakSelf.lineView).offset(15);
        make.right.equalTo(weakSelf.selButton.mas_left).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    [self.selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom).offset(14);
        make.right.equalTo(weakSelf.lineView).offset(-10);
        make.width.mas_equalTo(@87);
        make.height.mas_equalTo(@32);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.authcodeTextF.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.lineView);
    }];
    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.authcodeTextF.mas_bottom).offset(30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.left.equalTo(weakSelf.view).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
        make.height.mas_equalTo(@40);
    }];
    
    
    
}

- (void) alertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)btnClickedLogin:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    self.navigationController.navigationBarHidden = YES;
}
@end


