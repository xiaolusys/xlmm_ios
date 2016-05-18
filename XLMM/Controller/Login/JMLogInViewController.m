//
//  JMLogInViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogInViewController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"
#import "JMPhonenumViewController.h"
#import "JMAuthcodeViewController.h"
#import "RegisterViewController.h"
#import "NSString+Encrypto.h"
#import "MiPushSDK.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "JMSelecterButton.h"
#import "VerifyPhoneViewController.h"
#import "SVProgressHUD.h"

#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"


@interface JMLogInViewController ()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *wechatBtn;

@property (nonatomic,strong) JMSelecterButton *phoneNumBtn;

@property (nonatomic,strong) JMSelecterButton *captchaBtn;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *cancleBtn;


@end

@implementation JMLogInViewController {
    NSMutableString *randomstring;
    NSDictionary *dic;
    NSString *phoneNumber;
}


- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:nil selecotr:@selector(btnClick:)];
    
    
    [self initUI];
    [self initAutolayout];
    [self isWechatInstall];
    
}
//判断是否安装
- (void)isWechatInstall {
    
    if ([WXApi isWXAppInstalled]) {
        self.wechatBtn.enabled = YES;
        //        self.wechatBtn.hidden = NO;
    }else {
        self.wechatBtn.enabled = NO;
        //        self.wechatBtn.hidden = YES;
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
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRed:243/255. green:243/255. blue:244/255. alpha:1.];
    
    UIButton *cancleBtn = [[UIButton alloc] init];
    [self.headView addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"cancle_login"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setAdjustsImageWhenHighlighted:NO];
    //========微信登录按钮
    UIButton *wechatBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:wechatBtn];
    self.wechatBtn = wechatBtn;
    [wechatBtn setAdjustsImageWhenHighlighted:NO];
    [wechatBtn addTarget:self action:@selector(wechatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn setImage:[UIImage imageNamed:@"weichat_login"] forState:UIControlStateNormal];
    // ===== 手机号登录按钮
    JMSelecterButton *phoneNumBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:phoneNumBtn];
    self.phoneNumBtn = phoneNumBtn;
    [phoneNumBtn addTarget:self action:@selector(jumpToPhoneLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [phoneNumBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"手机登录" TitleFont:13. CornerRadius:20.];
    
    
    // ==== 验证码登录按钮
    JMSelecterButton *captchaBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:captchaBtn];
    self.captchaBtn = captchaBtn;
    [captchaBtn addTarget:self action:@selector(jumpToAuthcodeLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [captchaBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"短信登录" TitleFont:13. CornerRadius:20.];
    
    
    // ==== 注册登录按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:registerBtn];
    self.registerBtn = registerBtn;
    [registerBtn addTarget:self action:@selector(jumpToRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:155/255. green:155/255. blue:155/255. alpha:1.0] forState:UIControlStateNormal];
    
    UIView *lineView = [[UIView alloc] init];
    [self.bottomView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithRed:232/255. green:223/255. blue:224/255. alpha:1.0];
    
    
    
}


#pragma mark --- 注册微信登录的通知
- (void)viewWillAppear:(BOOL)animated {
    
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
    if (islogin) {
        // [self.navigationController popViewControllerAnimated:NO];
        // test ying's change
    }
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self selector: @selector (update:) name: @"login" object: nil ];
    
}

#pragma mark --- 监听微信登录的通知
- (void)update:(NSNotificationCenter *)notification {
    
    [SVProgressHUD showWithStatus:@"正在登录......"];

    dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
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
        
        [self loginSuccessful];
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"login"];
        [userdefaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
    
}
#pragma mark --- 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    
}
#pragma mark ---- 点击微信登录的按钮
- (void)wechatBtnClick:(UIButton *)btn {
    
    self.wechatBtn.enabled = NO;
    
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


#pragma mark ---- 选择使用手机号登录 或者 验证码 或者 注册新的账号

- (void)cancleBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转到手机号登陆
- (void)jumpToPhoneLoginVC:(UIButton *)btn {
    JMPhonenumViewController *phoneL = [[JMPhonenumViewController alloc] init];
    
    
    
    [self.navigationController pushViewController:phoneL animated:YES];
    
    
}
//跳转到验证码登录
- (void)jumpToAuthcodeLoginVC:(UIButton *)btn {
    
    JMAuthcodeViewController *authL = [[JMAuthcodeViewController alloc] init];
    
    authL.config = @{@"title":@"短信验证码登录",@"isRegister":@YES,@"isMessageLogin":@YES};
    
    [self.navigationController pushViewController:authL animated:YES];
    
}
//跳转到注册界面
- (void)jumpToRegisterVC:(UIButton *)btn {
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    
    verifyVC.config = @{@"title":@"手机注册",@"isRegister":@YES, @"isMessageLogin":@NO};
    
    [self.navigationController pushViewController:verifyVC animated:YES];
    
}



#pragma mark ---- 微信登录成功调用函数
- (void) loginSuccessful {
    
    [SVProgressHUD dismiss];
    
    [MobClick profileSignInWithPUID:@"playerID"];
    
    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"weixinlogin" object:self];
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter postNotification: broadcastMessage];
    
    [self setDevice];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    NSInteger count = self.navigationController.viewControllers.count;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    
}

#pragma mark ---- 登录成功后获取Device
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

- (void)btnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT - 200);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(30);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.height.mas_equalTo(@43);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    
    [self.phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatBtn.mas_bottom).offset(15);
        make.left.equalTo(self.wechatBtn.mas_left);
        make.right.equalTo(self.wechatBtn.mas_centerX).offset(-25/2);
        make.height.mas_equalTo(@43);
    }];
    
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumBtn);
        make.right.equalTo(self.wechatBtn.mas_right);
        make.left.equalTo(self.wechatBtn.mas_centerX).offset(25/2);
        make.height.mas_equalTo(@43);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumBtn.mas_bottom).offset(25);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@1);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(27);
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(@28);
    }];
}


@end




















