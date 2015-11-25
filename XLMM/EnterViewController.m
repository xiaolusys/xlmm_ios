//
//  EnterViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/11.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "EnterViewController.h"
#import "LogInViewController.h"
#import "MMClass.h"
#import "WXApi.h"
#import "WXLoginController.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Encrypto.h"
#import "UIViewController+NavigationBar.h"
#import "SettingPsdViewController.h"



#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"

@interface EnterViewController ()<WXApiDelegate>{
    NSMutableString *randomstring;
    BOOL isBangding;
    BOOL isSettingPsd;
    NSDictionary *dic;
    NSString *phoneNumber;
}

@property (nonatomic, copy)NSString *access_token;

@property (nonatomic, copy)NSString *openid;

@property (nonatomic, copy)NSString *wxCode;

@end

@implementation EnterViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
    if (islogin) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self selector: @selector (update:) name: @"login" object: nil ];
    
  
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self setInfo];
    
    [self createNavigationBarWithTitle:@"小鹿美美" selecotr:@selector(btnClicked:)];
    
    NSString *strings = @"noncestr=1442995986abcdef&secret=3c7b4e3eb5ae4c&timestamp=1442995986";
    isBangding = NO;
    NSLog(@"%@", [strings sha1]);
    if ([[strings sha1] isEqualToString:@"39ae931c59394c9b4b0973b3902956f63a35c21e"]) {
        NSLog(@"****一样的\n");
    }
    //检查用户是否安装了微信客户端
    
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        self.wxButton.hidden = NO;
    }
    else{
        NSLog(@"没有安装微信");
        self.wxButton.hidden = YES;
    }
    randomstring = [[NSMutableString alloc] init];
    
    self.wxButton.layer.cornerRadius = 20;
    self.zhanghaoButton.layer.cornerRadius = 20;
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
    
    long time = [timeSp integerValue];
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
            SettingPsdViewController *passVC = [[SettingPsdViewController alloc] initWithNibName:@"SettingPsdViewController" bundle:nil];
            passVC.phoneNumber = phoneNumber;
            passVC.info = dic;
            [self.navigationController pushViewController:passVC animated:YES];
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

- (IBAction)mmLogin:(id)sender {
    LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    NSLog(@"账号登录");
    
}

- (IBAction)weixinLogin:(id)sender {
    NSLog(@"微信登录");
    
    [self sendAuthRequest];
    
}
-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"xiaolumeimei" ;
    NSLog(@"req = %@", req);
    [WXApi sendReq:req];
}
@end
