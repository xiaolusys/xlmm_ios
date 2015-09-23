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

@interface EnterViewController ()<WXApiDelegate>{
    NSTimer *theTimer;
    NSMutableString *randomstring;
    
    
    
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
    
    NSArray *array = [self.navigationController viewControllers];
    NSLog(@"array = %@", array);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setInfo];
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self selector: @selector (update:) name: @"login" object: nil ];
    
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        
        self.wxButton.hidden = NO;

    }
    else{
        NSLog(@"没有安装微信");
        
        self.wxButton.hidden = YES;

    }
   // NSLog(@"randomArray = %@", [self randomArray]);
    randomstring = [[NSMutableString alloc] init];
    
    
}


/*
 
 
 
1442999252RwOO7Qb70y
1442999240QbaUmMxKys
14429992191wXjOfh0vf

 XPoAc9iDonWDsSdd8SL1
 hxnrW2q8bNW3FGq7CuTY
 Fq7OEkL7WZ0KhcSkCfud



*/


- (void)update:(NSNotificationCenter *)notification{
    NSLog(@"微信一键登录成功， 请您绑定手机号");
    
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSLog(@"用户信息 = %@", dic);
    
    //http://m.xiaolu.so/rest/v1/register/wxapp_login
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/register/wxapp_login", Root_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"urlString = %@", urlString);
    
    
    //微信登录 hash算法。。。。
    
    

    
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
    NSLog(@"count = %lu", count);
    int index = 0;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    long time = [timeSp longLongValue];
    NSLog(@"time = %ld", (long)time);
    
    for (int i = 0; i<10; i++) {
        index = arc4random()%count;
        // NSLog(@"index = %d", index);
        NSString *string = [randomArray objectAtIndex:index];
        [randomstring appendString:string];
    }
    NSLog(@"%@%@",timeSp ,randomstring);

    
    
    
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSString* dict = [NSString stringWithFormat:@"headimgurl=%@&nickname=%@&openid=%@&unionid=%@", [dic objectForKey:@"headimgurl"], [dic objectForKey:@"nickname"], [dic objectForKey:@"openid"], [dic objectForKey:@"unionid"]];
    NSLog(@"params = %@", dict);
    
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //  [self showAlertWait];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"response = %@", httpResponse);
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dictionary = %@", dictionary);
        
        NSLog(@"dataString = %@", str);
        
        
        
        //提示用户输入手机号和密码：
        
        
        
        
        
        if (httpResponse.statusCode != 200) {
            NSLog(@"出错了");
              return;
        }
        
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            return;
        }
        
    
        
        
        
    }];

    if ([[dic objectForKey:@"mobile"] isEqualToString:@""]) {
        NSLog(@"未绑定手机号码");
        WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
        wxloginVC.userInfo = dic;
        [self.navigationController pushViewController:wxloginVC animated:YES];

    } else {
        NSLog(@"已绑定手机号码");
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
    
    
 
    
    
    
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:YES forKey:@"login"];
    [userdefaults synchronize];
    
    
    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"login" object:nil];
}
- (void)setInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"小鹿美美";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}

- (NSArray *)randomArray{
//    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
//    return array;
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
    for (char i = 'A'; i<='Z'; i++) {
       // NSLog(@"%c", i);
        NSString *string = [NSString stringWithFormat:@"%c", i];
        
        [mutable addObject:string];
    }
    NSArray *array = [NSArray arrayWithArray:mutable];
    return array;
    
    
}



- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
    req.state = @"xiaolu" ;
    
    NSLog(@"req = %@", req);
    [WXApi sendReq:req];
}








@end
