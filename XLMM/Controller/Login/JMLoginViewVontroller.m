//
//  JMLoginViewVontroller.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLoginViewVontroller.h"
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


#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"


@interface JMLoginViewVontroller ()

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *wechatBtn;

@property (nonatomic,strong) UIButton *phoneNumBtn;

@property (nonatomic,strong) UIButton *captchaBtn;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) UIView *lineView;


@end

@implementation JMLoginViewVontroller {
    NSMutableString *randomstring;
    NSDictionary *dic;
    NSString *phoneNumber;

}


- (void)viewDidLoad {
    
    
    [self createNavigationBarWithTitle:nil selecotr:@selector(btnClick:)];
    
    
    [self initUI];
    [self initAutolayout];
    
    //先暂时的判断微信按钮是否可用
    [self isWechatInstall];
    
}
//判断是否安装
- (void)isWechatInstall {
    
    if ([WXApi isWXAppInstalled]) {
        //        self.wechatBtn.enabled = NO;
        self.wechatBtn.hidden = YES;
    }else {
        //        self.wechatBtn.enabled = YES;
        self.wechatBtn.hidden = NO;
    }
    
}


- (void)initUI {
    
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    //========微信登录按钮
    
    UIButton *wechatBtn = [[UIButton alloc] init];
    [self.view addSubview:wechatBtn];
    self.wechatBtn = wechatBtn;
    //    [wechatBtn addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    
    // ===== 手机号登录按钮
    UIButton *phoneNumBtn = [[UIButton alloc] init];
    [self.view addSubview:phoneNumBtn];
    self.phoneNumBtn = phoneNumBtn;
    [phoneNumBtn addTarget:self action:@selector(jumpToPhoneLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // ==== 验证码登录按钮
    UIButton *captchaBtn = [[UIButton alloc] init];
    [self.view addSubview:captchaBtn];
    self.captchaBtn = captchaBtn;
    [captchaBtn addTarget:self action:@selector(jumpToAuthcodeLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // ==== 注册登录按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    [self.view addSubview:registerBtn];
    self.registerBtn = registerBtn;
    [registerBtn addTarget:self action:@selector(jumpToRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    self.lineView = lineView;
    
    
    
    
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
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"login"];
        [userdefaults synchronize];
        [self loginSuccessful];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
    
}
#pragma mark --- 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];

}



#pragma mark ---- 选择使用手机号登录 或者 验证码 或者 注册新的账号
//跳转到手机号登陆
- (void)jumpToPhoneLoginVC:(UIButton *)btn {
    JMPhonenumViewController *phoneL = [[JMPhonenumViewController alloc] init];
    
    [self.navigationController pushViewController:phoneL animated:YES];
    
    
}
//跳转到验证码登录
- (void)jumpToAuthcodeLoginVC:(UIButton *)btn {
    
    JMAuthcodeViewController *authL = [[JMAuthcodeViewController alloc] init];
    
    [self.navigationController pushViewController:authL animated:YES];
    
}
//跳转到注册界面
- (void)jumpToRegisterVC:(UIButton *)btn {
    
    RegisterViewController *registerL = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerL animated:YES];
    
}


#pragma mark ---- 微信登录成功调用函数
- (void) loginSuccessful {
    [MobClick profileSignInWithPUID:@"playerID"];
    
    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"weixinlogin" object:self];
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter postNotification: broadcastMessage];
    
    [self setDevice];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
        make.top.equalTo(self.view.mas_top);
        make.width.mas_offset(SCREENWIDTH);
        make.height.mas_offset(SCREENWIDTH/5*6);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(self.headView.mas_bottom);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.mas_offset(self.view.mas_bottom);
    }];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(15);
    }];
    
    
    [self.phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_left).offset(15);
        make.left.equalTo(self.wechatBtn.mas_left);
        make.right.equalTo(self.wechatBtn.mas_centerX).offset(-25);
    }];
    
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumBtn.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.wechatBtn.mas_centerX).offset(25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumBtn.mas_bottom).offset(25);
        make.width.mas_offset(SCREENWIDTH);
        make.height.mas_offset(@(1/2));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}


@end




















