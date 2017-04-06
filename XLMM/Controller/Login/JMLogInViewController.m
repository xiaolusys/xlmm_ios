//
//  JMLogInViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogInViewController.h"
#import "WXApi.h"
#import "JMPhonenumViewController.h"
#import "MiPushSDK.h"
#import "JMSelecterButton.h"
#import "JMVerificationCodeController.h"


#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"

@interface JMLogInViewController ()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) JMSelecterButton *wechatBtn;

@property (nonatomic,strong) UIImageView *wexImage;

@property (nonatomic,strong) UILabel *wexTitleLabel;

@property (nonatomic,strong) JMSelecterButton *phoneNumBtn;

@property (nonatomic,strong) JMSelecterButton *captchaBtn;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *cancleBtn;

@property (nonatomic,strong) UILabel *titleLa;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation JMLogInViewController {
    NSMutableString *randomstring;
    NSDictionary *dic;
    NSString *phoneNumber;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:nil selecotr:@selector(btnClick1:)];
    
    [self initUI];
    [self initAutolayout];
    [self isWechatInstall];
    
}
//判断是否安装
- (void)isWechatInstall {
    
    if ([WXApi isWXAppInstalled]) {
        self.wechatBtn.enabled = YES;
        self.wechatBtn.hidden = NO;
    }else {
        self.wechatBtn.hidden = YES;
        self.wechatBtn.enabled = NO;
    }
    
}


- (void)initUI {
    UIImageView *headView = [[UIImageView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    headView.image = [UIImage imageNamed:@"login_background"];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.userInteractionEnabled = YES;
    self.headView.clipsToBounds = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"goodsDetailBackColorImage"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"goodsDetailBackColorImage"] forState:UIControlStateHighlighted];
    backButton.layer.cornerRadius = 18.;
    [backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    if (self.navigationController.viewControllers.count == 1) {
        self.backButton.hidden = YES;
    }else {
        self.backButton.hidden = NO;
    }

    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRed:243/255. green:243/255. blue:244/255. alpha:1.];
    
    //========微信登录按钮
    JMSelecterButton *wechatBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:wechatBtn];
    self.wechatBtn = wechatBtn;
    [wechatBtn setAdjustsImageWhenHighlighted:NO];
    [wechatBtn addTarget:self action:@selector(wechatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn setSureBackgroundColor:[UIColor wechatBackColor] CornerRadius:20.];
    [wechatBtn setImage:[UIImage imageNamed:@"wexImage_wither"] forState:UIControlStateNormal];
    [wechatBtn setTitle:@"微信注册登录" forState:UIControlStateNormal];
    wechatBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
    [wechatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // ===== 手机号登录按钮
    JMSelecterButton *phoneNumBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:phoneNumBtn];
    self.phoneNumBtn = phoneNumBtn;
    [phoneNumBtn addTarget:self action:@selector(jumpToPhoneLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [phoneNumBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"手机登录" TitleFont:15. CornerRadius:20.];
    
    // ==== 验证码登录按钮
    JMSelecterButton *captchaBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:captchaBtn];
    self.captchaBtn = captchaBtn;
    [captchaBtn addTarget:self action:@selector(jumpToAuthcodeLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [captchaBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"短信登录" TitleFont:15. CornerRadius:20.];
    
}
#pragma mark --- 注册微信登录的通知
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(WeChatLoginNoti:) name:@"WeChatLogin" object:nil];
    [MobClick beginLogPageView:@"JMLogInViewController"];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMLogInViewController"];
}
- (void)phoneNumberLogin:(NSNotification *)notification{
    //  NSLog(@"手机登录");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- 监听微信登录的通知
- (void)WeChatLoginNoti:(NSNotificationCenter *)notification {
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:kWxLoginUserInfo];
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
    [MBProgressHUD showLoading:@"正在登录......"];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/weixinapplogin?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    NSDictionary *newDic = @{@"headimgurl":[dic objectForKey:@"headimgurl"],
                             @"nickname":[dic objectForKey:@"nickname"],
                             @"openid":[dic objectForKey:@"openid"],
                             @"unionid":[dic objectForKey:@"unionid"],
                             @"devtype":LOGINDEVTYPE};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
        NSDictionary *result = responseObject;
        if (result.count == 0) {
            [MBProgressHUD hideHUD];
            return;
        }
        if ([[result objectForKey:@"rcode"]integerValue] != 0) {
            [MBProgressHUD hideHUD];
            [self alertMessage:[result objectForKey:@"msg"]];
            return;
        }
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:kIsLogin];
        [userdefaults synchronize];
        [self loginSuccessful];
        
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark --- 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WeChatLogin" object:nil];
}
#pragma mark ---- 点击微信登录的按钮
- (void)wechatBtnClick:(UIButton *)btn {
    self.wechatBtn.enabled = NO;
    [self performSelector:@selector(buttonEnable:) withObject:self.wechatBtn afterDelay:0.5];
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
- (void)buttonEnable:(UIButton *)button {
    button.enabled = YES;
}
#pragma mark ---- 选择使用手机号登录 或者 验证码 或者 注册新的账号
//跳转到手机号登陆
- (void)jumpToPhoneLoginVC:(UIButton *)btn {
    JMPhonenumViewController *phoneL = [[JMPhonenumViewController alloc] init];
    [self.navigationController pushViewController:phoneL animated:YES];
}
//跳转到验证码登录
- (void)jumpToAuthcodeLoginVC:(UIButton *)btn {
    JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
    verfyCodeVC.verificationCodeType = SMSVerificationCodeWithLogin;
    [self.navigationController pushViewController:verfyCodeVC animated:YES];
}
//跳转到注册界面
- (void)jumpToRegisterVC:(UIButton *)btn {
    JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
    verfyCodeVC.verificationCodeType = SMSVerificationCodeWithRegistered;
    [self.navigationController pushViewController:verfyCodeVC animated:YES];
}

#pragma mark ---- 微信登录成功调用函数
- (void)loginSuccessful {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"weixinlogin" object:self];
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter postNotification: broadcastMessage];
    [self setDevice];
    [self backApointInterface];
}
#pragma mark ---- 登录成功后获取Device
- (void)setDevice{
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
}
- (void)btnClick1:(UIButton *)btn {
}
- (void)btnClick:(UIButton *)btn {
    if (self.isTabBarLogin) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
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
    
    NSLog(@"array = %@", array);
    return array;
}

#pragma mark --- 弹出框视图
-(void) alertMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)initAutolayout {
    kWeakSelf
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT - 140);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headView).offset(10);
        make.top.equalTo(weakSelf.headView).offset(30);
        make.width.height.mas_equalTo(@(36));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.left.equalTo(weakSelf.view);
        make.height.mas_equalTo(140);
    }];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.bottomView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    
    [self.phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.wechatBtn.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.wechatBtn.mas_left);
        make.right.equalTo(weakSelf.wechatBtn.mas_centerX).offset(-25/2);
        make.height.mas_equalTo(@40);
    }];
    
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumBtn);
        make.right.equalTo(weakSelf.wechatBtn.mas_right);
        make.left.equalTo(weakSelf.wechatBtn.mas_centerX).offset(25/2);
        make.height.mas_equalTo(@40);
    }];
    
    
}
- (void)backApointInterface {
    [MBProgressHUD hideHUD];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if ((count > 2) && (count < [self.navigationController viewControllers].count)) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
        //        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}

/**
 *      for (UIViewController *controller in self.navigationController.viewControllers) {
 if ([controller isKindOfClass:[JMLogInViewController class]]) {
 count = [[self.navigationController viewControllers] indexOfObject:self];
 }
 }
 if (count > 2) {
 */



@end




















