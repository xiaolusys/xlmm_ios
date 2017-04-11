//
//  JMVerificationCodeController.m
//  XLMM
//
//  Created by zhang on 17/3/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMVerificationCodeController.h"
#import "JMSelecterButton.h"
#import "JMSliderLockView.h"
#import "JMGoodsCountTime.h"
#import "MiPushSDK.h"
#import "JMInstallPasswordController.h"
#import "WebViewController.h"
#import "JMRootTabBarController.h"
#import "Udesk.h"


@interface JMVerificationCodeController () <JMSliderLockViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
    BOOL isUnlock;
    BOOL isClickGetCode;
}

@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) JMSelecterButton *sureButton;
@property (nonatomic, strong) JMSelecterButton *verificationCodeButton;
@property (nonatomic, strong) JMSelecterButton *skipButton;
@property (nonatomic, strong) JMSliderLockView *sliderView;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *verificationCodeField;
@property (nonatomic, strong) UILabel *waringLabel;
@property (nonatomic, strong) UIButton *registeredButton;
@property (nonatomic, assign) BOOL isShowSliderView;
/**
 *  MaMa客服入口
 */
@property (nonatomic, strong) UIButton *serViceButton;

@end

@implementation JMVerificationCodeController

#pragma mark ==== 懒加载 ====
- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _maskScrollView.delegate = self;
    }
    return _maskScrollView;
}

#pragma mark ==== 生命周期函数 ====
- (instancetype)init {
    if (self = [super init]) {
        self.verificationCodeType = SMSVerificationCodeWithLogin;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMVerificationCodeController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.phoneNumberField resignFirstResponder];
    [self.verificationCodeField resignFirstResponder];
    [MobClick endLogPageView:@"JMVerificationCodeController"];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (IS_IOS8) {
    }else {
        if (self.verificationCodeType == SMSVerificationCodeWithBind) {
            self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
        }else {
            self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    
    self.fd_interactivePopDisabled = YES;
    isUnlock = NO;
    isClickGetCode = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.maskScrollView];
    [self createUI];
    [self craeteNavRightButton];
}

#pragma mark ==== 创建视图 ====
- (void)createUI {
    CGFloat firstSectionViewH = 120.;
    CGFloat spaceing = 15.f;
    CGFloat topSpace = 0.;
    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        topSpace = 200.;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.maskScrollView addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = [UIFont systemFontOfSize:14.];
        nameLabel.textColor = [UIColor buttonTitleColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.maskScrollView addSubview:nameLabel];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:13.];
        titleLabel.textColor = [UIColor dingfanxiangqingColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.maskScrollView addSubview:titleLabel];
        kWeakSelf
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.maskScrollView).offset(30);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
            make.width.height.mas_equalTo(@(90));
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
        }];
        
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.userInfo objectForKey:@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        nameLabel.text = [NSString stringWithFormat:@"微信号:%@", [self.userInfo objectForKey:@"nickname"]];
        titleLabel.text = @"为了更好的为您服务,请绑定手机号哦~!";
    }
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, topSpace, SCREENWIDTH, firstSectionViewH)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    
    UITextField *phoneNumberField = [self createTextFieldWithFrame:CGRectMake(spaceing, 15, SCREENWIDTH - spaceing * 2, 30) PlaceHolder:@"请输入手机号" KeyboardType:UIKeyboardTypeNumberPad];
    self.phoneNumberField = phoneNumberField;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneNumberField.cs_max_Y + 15, SCREENWIDTH, 1.0f)];
    lineView.backgroundColor = [UIColor lineGrayColor];
    UITextField *verificationCodeField = [self createTextFieldWithFrame:CGRectMake(spaceing, lineView.cs_max_Y + 15, SCREENWIDTH - spaceing * 2 - 100, 30 - lineView.cs_h) PlaceHolder:@"请输入验证码" KeyboardType:UIKeyboardTypeNumberPad];
    self.verificationCodeField = verificationCodeField;
    self.verificationCodeButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    self.verificationCodeButton.frame = CGRectMake(verificationCodeField.cs_max_X + 15, verificationCodeField.cs_y, 90, 30);
    [self.verificationCodeButton setNomalBorderColor:[UIColor buttonDisabledBorderColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"获取验证码" TitleFont:13. CornerRadius:15.];
//    [self verificationButton:-1];
    self.verificationCodeButton.titleLabel.text = @"获取验证码";
    self.verificationCodeButton.selected = NO;
    self.verificationCodeButton.enabled = NO;
    [self.verificationCodeButton addTarget:self action:@selector(getAuthcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.maskScrollView addSubview:textFieldView];
    [textFieldView addSubview:lineView];
    [textFieldView addSubview:phoneNumberField];
    [textFieldView addSubview:verificationCodeField];
    [textFieldView addSubview:self.verificationCodeButton];
    
    CGFloat registW = [@"如何注册" widthWithHeight:20. andFont:13.].width;
    self.registeredButton  = [[UIButton alloc] initWithFrame:CGRectMake(spaceing, textFieldView.cs_max_Y + 10, registW, 20)];
    [self.maskScrollView addSubview:self.registeredButton];
    //设置按钮文字的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"如何注册"];
    NSRange titleRange = {0,[title length]};
    [self.registeredButton setTitle:@"如何注册" forState:UIControlStateNormal];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.registeredButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.registeredButton.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    self.registeredButton.titleLabel.textColor = [UIColor redColor];
    [self.registeredButton addTarget:self action:@selector(registeredButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.waringLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceing, self.registeredButton.cs_max_Y + 10, SCREENWIDTH - spaceing * 2, 20)];
    [self.maskScrollView addSubview:self.waringLabel];
    self.waringLabel.text = @"";
    self.waringLabel.textColor = [UIColor redColor];
    self.waringLabel.font = CS_SYSTEMFONT(13.);
    self.waringLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.sliderView = [[JMSliderLockView alloc] initWithFrame:CGRectMake(spaceing, self.waringLabel.cs_max_Y + 10, SCREENWIDTH - spaceing * 2, 60)];
    self.sliderView.thumbHidden = NO;
    self.sliderView.thumbBack = YES;
    self.sliderView.text = @"向右滑动验证";
    self.sliderView.delegate = self;
    [self.sliderView setColorForBackgroud:[UIColor buttonDisabledBorderColor] foreground:[UIColor buttonEnabledBackgroundColor] thumb:[UIColor whiteColor] border:[UIColor lineGrayColor] textColor:[UIColor buttonTitleColor]];
    [self.sliderView setThumbBeginString:@"😊" finishString:@"😀"];
    [self.maskScrollView addSubview:self.sliderView];
    self.sliderView.cs_h = 0.f;
    
    self.sureButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.frame = CGRectMake(spaceing, self.sliderView.cs_max_Y + 20, SCREENWIDTH - spaceing * 2, 40);
    [self.sureButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.sureButton setSureBackgroundColor:[UIColor buttonEnabledBackgroundColor] CornerRadius:20.f];
    [self.sureButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:self.sureButton];
    
    switch (self.verificationCodeType) {
        case SMSVerificationCodeWithLogin:      // 验证码登录
            [self.sureButton setTitle:@"登录" forState:UIControlStateNormal];
            self.verificationCodeField.placeholder = @"请输入验证码";
            self.title = @"短信登录";
            break;
        case SMSVerificationCodeWithRegistered: // 注册新用户
            [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
            self.title = @"手机注册";
            break;
        case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
            [self.sureButton setTitle:@"绑定手机号" forState:UIControlStateNormal];
            self.title = @"手机绑定";
            break;
        case SMSVerificationCodeWithChangePWD:  // 修改密码
            [self.sureButton setTitle:@"下一步" forState:UIControlStateNormal];
            self.title = @"修改密码";
            break;
        case SMSVerificationCodeWithForgetPWD:  // 忘记密码
            [self.sureButton setTitle:@"下一步" forState:UIControlStateNormal];
            self.title = @"忘记密码";
            break;
        default:
            break;
    }
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    
    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        self.skipButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
        [self.maskScrollView addSubview:self.skipButton];
        [self.skipButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"跳过" TitleFont:14. CornerRadius:20.];
        self.skipButton.frame = CGRectMake(spaceing, self.sureButton.cs_max_Y + 10, SCREENWIDTH - spaceing * 2, 40);
        [self.skipButton addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
    }else {
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
    }
    
}
- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}
#pragma mark ---- 点击获取验证码按钮
- (void)getAuthcodeClick:(UIButton *)sender {
    [self.phoneNumberField resignFirstResponder];
    [self.verificationCodeField resignFirstResponder];
    if (self.userNotXLMM) {
        [MBProgressHUD showMessage:@"您还不是小鹿精英妈妈~!"];
        return;
    }
    isClickGetCode = YES;
    if ([NSString isStringEmpty:self.phoneNumberField.text]) {
        self.waringLabel.text = @"请输入手机号";
        return ;
    }
    if ([self.phoneNumberField.text hasPrefix:@"1"] && self.phoneNumberField.text.length == 11) {
    }else {
        self.waringLabel.text = @"请输入正确手机号";
        return ;
    }
    if (!isUnlock) {
        self.waringLabel.text = @"请滑动验证";
        return ;
    }
    NSString *phoneNumber = self.phoneNumberField.text;
    NSInteger num  = [[phoneNumber substringToIndex:1] integerValue];
    if (num == 1 && phoneNumber.length == 11) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = phoneNumber;
        switch (self.verificationCodeType) {
            case SMSVerificationCodeWithLogin:      // 验证码登录
                parameters[@"action"] = @"sms_login";
                break;
            case SMSVerificationCodeWithRegistered: // 注册新用户
                parameters[@"action"] = @"register";
                break;
            case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
                parameters[@"action"] = @"bind";
                break;
            case SMSVerificationCodeWithChangePWD:  // 修改密码
                parameters[@"action"] = @"change_pwd";
                break;
            case SMSVerificationCodeWithForgetPWD:  // 忘记密码
                parameters[@"action"] = @"find_pwd";
                break;
            default:
                break;
        }
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TSendCode_URL WithParaments:parameters WithSuccess:^(id responseObject) {
            NSInteger rcodeStr = [[responseObject objectForKey:@"rcode"] integerValue];
            if (rcodeStr == 0) {
                isClickGetCode = NO;
                [self startTime];
            }else {
                [self reductionSlider];
                [MBProgressHUD showWarning:[responseObject objectForKey:@"msg"]];
            }
        } WithFail:^(NSError *error) {
            [self reductionSlider];
            [MBProgressHUD showError:@"获取失败！"];
        } Progress:^(float progress) {
            
        }];
        
    }else {
        [MBProgressHUD showError:@"手机号错误！"];
    }
}
// === 验证码 ====
- (void)startTime {
    [JMGoodsCountTime initCountDownWithCurrentTime:61];
    kWeakSelf
    [JMGoodsCountTime shareCountTime].countBlock = ^(int second) {
        [weakSelf verificationButton:second];
//        second == -1 ? [weakSelf verificationButton:NO] : [weakSelf verificationButton:YES];
    };
}
- (void)verificationButton:(int)second {
    if (second == -1) {
        self.verificationCodeButton.titleLabel.text = @"获取验证码";
        self.verificationCodeButton.selected = YES;
        self.verificationCodeButton.enabled = YES;
        [self delayMethod];
    }else {
        self.verificationCodeButton.titleLabel.text = [NSString stringWithFormat:@" 剩余%02d秒",second];
        self.verificationCodeButton.selected = NO;
        self.verificationCodeButton.enabled = NO;
    }
    
}
- (void)reductionSlider {
    isUnlock = NO;
    isClickGetCode = NO;
    self.sliderView.thumbBack = YES;
    self.sliderView.text = @"向右滑动验证";
    self.sliderView.userInteractionEnabled = YES;
}

#pragma mark ==== 确定按钮点击 ====
- (void)loginBtnClick:(UIButton *)sender {
    if ([NSString isStringEmpty:self.phoneNumberField.text]) {
        self.waringLabel.text = @"请输入手机号";
        return ;
    }
    if ([self.phoneNumberField.text hasPrefix:@"1"] && self.phoneNumberField.text.length == 11) {
    }else {
        self.waringLabel.text = @"请输入正确手机号";
        return ;
    }
    if ([NSString isStringEmpty:self.verificationCodeField.text]) {
        self.waringLabel.text = @"请输入验证码";
        return ;
    }
    if (self.verificationCodeField.text.length >= 4 && self.verificationCodeField.text.length <= 6) {
    }else {
        self.waringLabel.text = @"请输入正确的验证码";
        return ;
    }
    NSString *phoneNumber = self.phoneNumberField.text;
    NSString *vcode = self.verificationCodeField.text;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    self.waringLabel.text = @"";
    parameters[@"mobile"] = phoneNumber;
    parameters[@"verify_code"] = vcode;
    switch (self.verificationCodeType) {
        case SMSVerificationCodeWithLogin:      // 验证码登录
            parameters[@"action"] = @"sms_login";
            parameters[@"devtype"] = LOGINDEVTYPE;
            [MBProgressHUD showLoading:@"登录中....."];
            break;
        case SMSVerificationCodeWithRegistered: // 注册新用户
            parameters[@"action"] = @"register";
            parameters[@"devtype"] = LOGINDEVTYPE;
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
            parameters[@"action"] = @"bind";
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithChangePWD:  // 修改密码
            parameters[@"action"] = @"change_pwd";
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithForgetPWD:  // 忘记密码
            parameters[@"action"] = @"find_pwd";
            [MBProgressHUD showLoading:@""];
            break;
        default:
            break;
    }
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TVerifyCode_URL WithParaments:parameters WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self verifyAfter:responseObject];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [self reductionSlider];
        [MBProgressHUD showError:@"请求失败,请稍后重试~!"];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)verifyAfter:(NSDictionary *)dic {
    if (dic.count == 0)return;
    NSString *phoneNumber = self.phoneNumberField.text;
    if ([[dic objectForKey:@"rcode"] integerValue] != 0) {
        [self reductionSlider];
        [self alertMessage:[dic objectForKey:@"msg"]];
        return;
    }
    if (self.verificationCodeType == SMSVerificationCodeWithRegistered || self.verificationCodeType == SMSVerificationCodeWithLogin) {
        [self alertMessage:[dic objectForKey:@"msg"]];
        NSDictionary *params = [[NSUserDefaults standardUserDefaults]objectForKey:@"MiPush"];
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
            NSString *user_account = [responseObject objectForKey:@"user_account"];
            if ([user_account isEqualToString:@""]) {
            } else {
                [MiPushSDK setAccount:user_account];
                //保存user_account
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:user_account forKey:@"user_account"];
                [user synchronize];
            }
        } WithFail:^(NSError *error) {
        } Progress:^(float progress) {
        }];
        //设置用户名在newLeft中使用
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:phoneNumber forKey:kUserName];
        [user setBool:YES forKey:kIsLogin];
        //发送通知在root中接收
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumberLogin" object:nil];
        [self backApointInterface];
        JMRootTabBarController * tabBarVC = [[JMRootTabBarController alloc] init];
        JMKeyWindow.rootViewController = tabBarVC;
    }else if (self.verificationCodeType == SMSVerificationCodeWithForgetPWD) {
        JMInstallPasswordController *pwdVC = [[JMInstallPasswordController alloc] init];
        pwdVC.pwdType = 0;
        pwdVC.verfiyCode = self.verificationCodeField.text;
        pwdVC.phomeNumber = self.phoneNumberField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }else if (self.verificationCodeType == SMSVerificationCodeWithChangePWD) {
        JMInstallPasswordController *pwdVC = [[JMInstallPasswordController alloc] init];
        pwdVC.pwdType = 1;
        pwdVC.verfiyCode = self.verificationCodeField.text;
        pwdVC.phomeNumber = self.phoneNumberField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }else {
        [self backApointInterface];
        JMRootTabBarController * tabBarVC = [[JMRootTabBarController alloc] init];
        JMKeyWindow.rootViewController = tabBarVC;
    }
}


#pragma mark ==== UITextField 代理实现 ====
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    [self disEnableSureButton];
//    if (textField == self.phoneNumberField) {
//        
//    }else {
//    
//    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    NSLog(@"%@",muString);
    if (textField == self.phoneNumberField) {
        if ([muString hasPrefix:@"1"] && muString.length == 11) {
            if (self.userNotXLMM) {
                
            }else {
                self.sliderView.cs_h = 60.f;
                self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
                if (self.verificationCodeType == SMSVerificationCodeWithBind) {
                    self.skipButton.cs_y = self.sureButton.cs_max_Y + 10;
                    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
                }else {
                    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
                }
            }
            self.verificationCodeButton.selected = YES;
            self.verificationCodeButton.enabled = YES;
        }else {
            self.sliderView.cs_h = 0.f;
            self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
            if (self.verificationCodeType == SMSVerificationCodeWithBind) {
                self.skipButton.cs_y = self.sureButton.cs_max_Y + 10;
                self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
            }else {
                self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
            }
//            [self verificationButton:NO];
            self.verificationCodeButton.selected = NO;
            self.verificationCodeButton.enabled = NO;
        }
    }
    return YES;
}
#pragma mark ==== 重写 isShowSliderView 的SET方法 ====
- (void)setIsShowSliderView:(BOOL)isShowSliderView {
    if (isShowSliderView == _isShowSliderView) {
        return ;
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (isShowSliderView) {
            [self.view addSubview:self.sliderView];
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.cs_h = 60.f;
                self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.cs_h = 0.f;
                self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
            } completion:^(BOOL finished) {
                [self.sliderView removeFromSuperview];
            }];
        }
    } completion:^(BOOL finished) {
        if (!isShowSliderView) {
        }
    }];
    _isShowSliderView = isShowSliderView;
}
#pragma mark ==== 滑动验证视图 代理 ====
- (void)sliderEndValueChanged:(JMSliderLockView *)slider{
    if (slider.value >= 1) {
        slider.thumbBack = NO;
        if (self.verificationCodeButton.selected) {
            if (isClickGetCode) { // 已经点击获取验证码按钮
                isUnlock = YES;
                self.sliderView.text = @"验证成功";
                self.waringLabel.text = @"";
                self.sliderView.userInteractionEnabled = NO;
                [self getAuthcodeClick:self.verificationCodeButton];
            }else { // 没有点击
                [self changeSliderStatus:@"请点击获取验证码"];
            }
        }else {
            [self changeSliderStatus:@"请填写手机号与短信验证码"];
            
        }
        //        [slider setSliderValue:1.0];
    }
}
- (void)changeSliderStatus:(NSString *)textStrint {
    self.sliderView.text = @"验证成功";
    self.waringLabel.text = textStrint;
    isUnlock = NO;
    __block JMVerificationCodeController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf delayMethod];
    });
}
- (void)sliderValueChanging:(JMSliderLockView *)slider{
    //        NSLog(@"%f",slider.value);
}
- (void)delayMethod {
    self.sliderView.cs_h = 0.f;
    self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        self.skipButton.cs_y = self.sureButton.cs_max_Y + 10;
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
    }else {
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
    }
    [self performSelector:@selector(showSliderView) withObject:self.sliderView afterDelay:2.f];
}
- (void)showSliderView {
    self.sliderView.cs_h = 60.f;
    self.sureButton.cs_y = self.sliderView.cs_max_Y + 20;
    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        self.skipButton.cs_y = self.sureButton.cs_max_Y + 10;
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.skipButton.cs_max_Y + 20);
    }else {
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.sureButton.cs_max_Y + 20);
    }
    self.waringLabel.text = @"";
    self.sliderView.text = @"向右滑动验证";
    self.sliderView.thumbBack = YES;
}

// ==== 底部确定按钮状态变化 ====
- (void)enableSureButton {
    self.sureButton.enabled = YES;
    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
}
- (void)disEnableSureButton {
    self.sureButton.enabled = NO;
    self.sureButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.phoneNumberField resignFirstResponder];
    [self.verificationCodeField resignFirstResponder];
}
- (void)skipClick {
    [self backApointInterface];
}
- (void) alertMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
- (void)backClick {
    if (self.userLoginMethodWithWechat) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self backApointInterface];
    }
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

- (void)craeteNavRightButton {
    NSString *userName = self.profileUserInfo ? self.profileUserInfo[@"nick"] : @"新用户";
    NSString *userID = self.profileUserInfo ? self.profileUserInfo[@"id"] : @"-1";
    NSDictionary *parameters = @{
                                 @"user": @{
                                         @"sdk_token":userID,
                                         @"nick_name":userName,
                                         }
                                 };
    [UdeskManager createCustomerWithCustomerInfo:parameters];
    UIButton *serViceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    [serViceButton addTarget:self action:@selector(serViceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [serViceButton setTitle:@"小鹿客服" forState:UIControlStateNormal];
    [serViceButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    serViceButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    //    UIImageView *serviceImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    //    [serViceButton addSubview:serviceImage];
    //    serviceImage.image = [UIImage imageNamed:@"serviceEnter"];
    self.serViceButton = serViceButton;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:serViceButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)serViceButtonClick:(UIButton *)button {
    [MobClick event:@"MaMa_service"];
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:1.0f];
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}


@end























































































