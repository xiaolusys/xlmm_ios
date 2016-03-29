//
//  MMRootViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMRootViewController.h"
#import "RESideMenu.h"
#import "TodayViewController.h"
#import "PreviousViewController.h"
#import "ChildViewController.h"
#import "MMClass.h"
#import "LogInViewController.h"
#import "UIImage+ColorImage.h"
#import "CartViewController.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "MMCartsView.h"
#import "MMNavigationDelegate.h"
#import "LogInViewController.h"
#import "WXApi.h"
#import "MaMaViewController.h"
#import "YouHuiQuanViewController.h"
#import "XiangQingViewController.h"
#import "MaMaPersonCenterViewController.h"
#import "MMLoginStatus.h"
#import "AFNetworking.h"
#import "NSString+Encrypto.h"
#import "PublishNewPdtViewController.h"
#import "ActivityView.h"
#import "NSString+URL.h"


#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"




#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MMRootViewController ()<MMNavigationDelegate, WXApiDelegate>{
    UIView *_view;
    UIPageViewController *_pageVC;
    NSArray *_pageContentVC;
    NSInteger _pageCurrentIndex;
    UIButton *leftButton;
    BOOL _isFirst;
    NSInteger goodsCount;
    UILabel *label;
    CGRect frame;
    NSInteger _currentIndex;
    UIBarButtonItem *rightItem;
    UIView *dotView;
    UILabel *countLabel;
    NSNumber *last_created;
    NSTimer *theTimer;
    
}

@property (nonatomic, strong)ActivityView *startV;
@property (nonatomic, strong)NSTimer *sttime;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)NSString *imageUrl;

@end

@implementation MMRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
//    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156 , 44, 44);
    [self setLabelNumber];
  
}

- (void)updataAfterLogin:(NSNotification *)notification{
  //  NSLog(@"微信登录");
    
//    MMLoginStatus *login = [MMLoginStatus shareLoginStatus];
//    if (login.isxlmm) {
//        [self createRightItem];
//    } else {
//          self.navigationItem.rightBarButtonItem = nil;
//    }

  
    if ([self loginUpdateIsXiaoluMaMa]) {
        [self createRightItem];
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)phoneNumberLogin:(NSNotification *)notification{
  //  NSLog(@"手机登录");
    if ([self loginUpdateIsXiaoluMaMa]) {
        [self createRightItem];
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)isXiaolumama{
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (!responseObject)return ;
//        return YES;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        return NO;
//    }];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
//    if (data == nil) {
//        return NO;
//    }
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"dic = %@", dic);
//    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
//    return YES;
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isXLMM = [users boolForKey:@"isXLMM"];
    return isXLMM;
}

- (BOOL)loginUpdateIsXiaoluMaMa {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        return NO;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
}

- (void)createRightItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
    rightImageView.frame = CGRectMake(18, 11, 26, 26);
    [rightBtn addSubview:rightImageView];
    rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark 解析targeturl 跳转到不同的界面
- (void)presentView:(NSNotification *)notification{
    NSLog(@"跳转新的界面");
    
    NSLog(@"userInfo = %@", notification.userInfo);
    NSString *target_url = [notification.userInfo objectForKey:@"target_url"];
    
    if (target_url == nil) {
        return;
    }
    
    NSLog(@"target_url = %@", target_url);
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_today"]) {
        NSLog(@"跳到今日上新");
        [self buttonClicked:100];
      
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_previous"]){
        NSLog(@"跳到昨日推荐");
        [self buttonClicked:101];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/childlist"]){
        NSLog(@"跳到潮童专区");
        [self buttonClicked:102];
      
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/ladylist"]){
        NSLog(@"跳到时尚女装");
        [self buttonClicked:103];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/usercoupons/method"]){
        NSLog(@"跳转到用户未过期优惠券列表");
        
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        [self.navigationController pushViewController:youhuiVC animated:YES];
        
        
        
    }  else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_home"]){
        
        //  跳转到小鹿妈妈界面。。。
        
        
        
        MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:ma animated:YES];
        
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_0day"]){
        
        NSLog(@"跳转到小鹿妈妈每日上新");
        
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [self.navigationController pushViewController:publish animated:YES];
        
    }else {
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        
        NSString *parameter = [components lastObject];
        NSArray *params = [parameter componentsSeparatedByString:@"="];
        NSString *firstparam = [params firstObject];
        if ([firstparam isEqualToString:@"model_id"]) {
            NSLog(@"跳到集合页面");
            NSLog(@"model_id = %@", [params lastObject]);
            
            
            MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[params lastObject] isChild:NO];
            
            [self.navigationController pushViewController:collectionVC animated:YES];
            
            
            
        } else if ([firstparam isEqualToString:@"product_id"]){
            NSLog(@"跳到商品详情");
            NSLog(@"product_id = %@", [params lastObject]);
            
            MMDetailsViewController *details = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:[params lastObject] isChild:NO];
            [self.navigationController pushViewController:details animated:YES];
       
            
        } else if ([firstparam isEqualToString:@"trade_id"]){
            NSLog(@"跳到订单详情");
            NSLog(@"trade_id = %@", [params lastObject]);
            
            
            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
            //http://m.xiaolu.so/rest/v1/trades/86412/details
            
           // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
            xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, [params lastObject]];
            NSLog(@"url = %@", xiangqingVC.urlString);
            
            
            [self.navigationController pushViewController:xiangqingVC animated:YES];
            
            
        } else {
            
            //  跳转到H5 界面 。。。。。
            
            
            NSLog(@"跳到H5首页");
            
        }
    }
}

- (void)showNotification:(NSNotification *)notification{
    NSLog(@"弹出提示框");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
  
    if (_isFirst) {

    }else{
        
//        UIView *cartView = [_view viewWithTag:123];
//        cartView.frame = CGRectMake(2, SCREENHEIGHT - 166, 44, 44);
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    _isFirst = NO;
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
     frame = self.view.frame;
    

    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    frame = self.view.frame;
}

#pragma mark 注册观察者
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    self.timeCount = 0;
    //启动活动页
    self.startV = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.startV];
    
    NSString *activityUrl = [NSString stringWithFormat:@"%@/rest/v1/activitys/startup_diagrams", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:activityUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        if (responseObject[@"picture"] == nil)return;
        [self startDeal:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    //订阅展示视图消息，将直接打开某个分支视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
    //弹出消息框提示用户有订阅通知消息。主要用于用户在使用应用时，弹出提示框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification:) name:@"Notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(setLabelNumber) name:@"logout" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpHome:) name:@"fromActivityToToday" object:nil];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirst = YES;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+34.9, WIDTH, HEIGHT - 20 - 5 - 28 - 2)];
    [self.view addSubview:_view];
    _pageCurrentIndex = 0;
    
    
    [self createInfo];
    
    [self creatPageData];
    
    //[self islogin];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self autologin];
    } else {
        NSLog(@"no login");
    }
    
    self.sttime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ActivityTimeUpdate) userInfo:nil repeats:YES];
}

- (void)startDeal:(NSDictionary *)dic {
    self.imageUrl = [dic objectForKey:@"picture"];
    
    if (self.imageUrl.length == 0 || [self.imageUrl class] == [NSNull class]) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
    }
    [self.startV.imageV sd_setImageWithURL:[NSURL URLWithString:[self.imageUrl imagePostersCompression]]];
}

- (void)ActivityTimeUpdate {
    self.timeCount++;
    if (self.timeCount > 2) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];

    }
}


- (void)jumpHome:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *jumpType = info[@"param"];
    if ([jumpType isEqualToString:@"previous"]) {
        [self buttonClicked:101];
    }else if ([jumpType isEqualToString:@"child"]) {
        [self buttonClicked:102];
    }else if ([jumpType isEqualToString:@"woman"]) {
        [self buttonClicked:103];
    }
    NSLog(@"---跳转－－－－%@", jumpType);
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
    
   // NSLog(@"array = %@", array);
    return array;
}

- (void)weixinzidongdenglu{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
  //  NSLog(@"用户信息 = %@", dic);
    //微信登录 hash算法。。。。
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
//    NSLog(@"count = %lu", count);
    int index = 0;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
 //   NSLog(@"timeSp:%@",timeSp);
    
    __unused long time = [timeSp integerValue];
  //  NSLog(@"time = %ld", (long)time);
    NSMutableString * randomstring = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = 0; i<8; i++) {
        index = arc4random()%count;
        // NSLog(@"index = %d", index);
        NSString *string = [randomArray objectAtIndex:index];
        [randomstring appendString:string];
    }
  //  NSLog(@"%@%@",timeSp ,randomstring);
    //    NSString *secret = @"3c7b4e3eb5ae4c";
    NSString *noncestr = [NSString stringWithFormat:@"%@%@", timeSp, randomstring];
    //获得参数，升序排列
    NSString* sign_params = [NSString stringWithFormat:@"noncestr=%@&secret=%@&timestamp=%@",noncestr, SECRET,timeSp];
 //   NSLog(@"1.————》%@", sign_params);
    
    NSString *sign = [sign_params sha1];
    NSString *dict;
    
 //   NSLog(@"sign = %@", sign);
    
    
    //http://m.xiaolu.so/rest/v1/register/wxapp_login
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/register/wxapp_login?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    NSURL *url = [NSURL URLWithString:urlString];
   // NSLog(@"urlString = %@", urlString);
    if (url == nil) {
        return;
    }
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    dict = [NSString stringWithFormat:@"headimgurl=%@&nickname=%@&openid=%@&unionid=%@", [dic objectForKey:@"headimgurl"], [dic objectForKey:@"nickname"],[dic objectForKey:@"openid"],[dic objectForKey:@"unionid"]];
    
  //  NSLog(@"params = %@", dict);
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        return;
    }
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSData *data2 = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    if (data2 == nil) {
        return;
    }
  __unused  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data2 options:kNilOptions error:nil];
    
    
   // NSLog(@"dictionary = %@", dictionary);
    
    //   http://m.xiaolu.so/rest/v1/users/need_set_info
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:YES forKey:@"login"];
    [userdefaults synchronize];

}

- (void)shoujizidongdenglu{
  //  NSLog(@"手机自动登录");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:kUserName];
    NSString *password = [defaults objectForKey:kPassWord];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
  //  NSLog(@"userName : %@, password : %@", username, password);
    
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password
                                 };
    
    
    
    [manager POST:kLOGIN_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
           //   NSLog(@"JSON: %@", responseObject);
         //     NSLog(@"手机自动登录成功。。。。");
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //     NSLog(@"Error: %@", error);
              
              
          }];

}

- (void)autologin{
    
   
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginMethon = [defaults objectForKey:kLoginMethod];
    if ([loginMethon isEqualToString:kWeiXinLogin]) {
      //  NSLog(@"微信登录");
        
        [self weixinzidongdenglu];
       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
      //  NSLog(@"userinfo = %@", userinfo);
        if ([self isXiaolumama]) {
            [self createRightItem];
        } else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else if ([loginMethon isEqualToString:kPhoneLogin]){
      
       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
      //  NSLog(@"userinfo = %@", userinfo);
        if ([self isXiaolumama]) {
            [self createRightItem];
        } else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }
   
}


- (void)islogin{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/islogin", Root_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error == nil) {
        __unused NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil) {
          //  NSLog(@"dic = %@", dic);
        } else{
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    } else{
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark  设置导航栏样式
- (void)createInfo{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
    imageView.frame = CGRectMake(0, 8, 83, 20);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [view addSubview:imageView];
    imageView.center = view.center;
    CGRect imageframe = imageView.frame;
    imageframe.origin.y += 2;
    imageView.frame = imageframe;
    self.navigationItem.titleView = view;
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles.png"]];
    leftImageview.frame = CGRectMake(0, 11, 26, 26);
    [leftButton addSubview:leftImageview];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
   

    [self.view addSubview:[[UIView alloc] init]];
}

#pragma mark 小鹿妈妈入口
- (void)rightClicked:(UIButton *)button{
//    NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaults boolForKey:kIsLogin];
    if (islogin == YES) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
        NSError *error = nil;
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:string] encoding:NSUTF8StringEncoding error:&error];
      //  NSLog(@"error = %@", error);
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
       // NSLog(@"json = %@", json);
        if ([[json objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]) {
            MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
            [self.navigationController pushViewController:ma animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不是小鹿妈妈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } else {
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


#pragma mark 生成pageController数据。。。
- (void)creatPageData{
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = _view.bounds;
    _pageVC.view.userInteractionEnabled = YES;
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    TodayViewController *todayVC = [[TodayViewController alloc] initWithNibName:@"TodayViewController" bundle:nil];
    todayVC.delegate = self;
    PreviousViewController *preVC = [[PreviousViewController alloc] initWithNibName:@"PreviousViewController" bundle:nil];
    preVC.delegate = self;
    ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    childVC.urlString = kCHILD_LIST_URL;
    childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
    childVC.childClothing = YES;
    childVC.delegate = self;
    ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    womanVC.urlString = kLADY_LIST_URL;
    womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
    womanVC.childClothing = NO;
    womanVC.delegate = self;
    _pageContentVC = @[todayVC, preVC, childVC, womanVC];
    [_pageVC setViewControllers:@[todayVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:_pageVC];
    [_view addSubview:_pageVC.view];
    [self createCartsView];
    [_pageVC didMoveToParentViewController:self];
    for (UIView *v in  _pageVC.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
}

#pragma mark 创建购物车按钮。。
- (void)createCartsView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT - 156, 108, 44)];
    view.tag = 123;
    [_view addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor settingBackgroundColor].CGColor;
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    iconView.image = [UIImage imageNamed:@"gouwucheicon2.png"];
    iconView.userInteractionEnabled = NO;
    [button addSubview:iconView];
//    button.backgroundColor = [UIColor redColor];
    
    dotView = [[UIView alloc] initWithFrame:CGRectMake(26, 4, 16, 16)];
    dotView.layer.cornerRadius = 8;
    dotView.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    [button addSubview:dotView];
    dotView.hidden = YES;
    
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 60, 24)];
    countLabel.text = @"";
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentLeft;
    [button addSubview:countLabel];
    label = [[UILabel alloc] initWithFrame:dotView.bounds];
    label.font = [UIFont systemFontOfSize:10];
    [dotView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    countLabel.userInteractionEnabled = NO;
    dotView.userInteractionEnabled = NO;
    label.userInteractionEnabled = NO;
    countLabel.hidden = YES;
    
    
    
}
#pragma mark 设置购物车数量


- (void)setLabelNumber{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == NO) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        
        label.text = @"0";
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num.json", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            label.text = @"0";
            dotView.hidden = YES;
            countLabel.hidden = YES;
            UIView *view = [_view viewWithTag:123];
            CGRect rect = view.frame;
            rect.size.width = 44;
            view.frame = rect;
            return ;
        }else {
            [self cartViewUpdate:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
   
    
}

- (void)cartViewUpdate:(NSDictionary *)dic {
    // NSLog(@"dic = %@", dic);
    last_created = [dic objectForKey:@"last_created"];
    goodsCount = [[dic objectForKey:@"result"]integerValue];
    if (goodsCount == 0) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        return;
    }
    label.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"result"] stringValue]];
    dotView.hidden = NO;
    countLabel.hidden = NO;
    UIView *view = [_view viewWithTag:123];
    CGRect rect = view.frame;
    rect.size.width = 108;
    view.frame = rect;
    
    [self createTimeLabel];
}


- (void)createTimeLabel{
    countLabel.hidden = NO;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)thetimer
{
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[last_created doubleValue]];
    // NSLog(@"%@", lastDate);
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:lastDate options:0];
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    //   NSLog(@"string = %@", string);
    if ([d minute] < 0 || [d second] < 0) {
        string = @"";
        
        UIView *view = [_view viewWithTag:123];
        dotView.hidden = YES;
        
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        if ([theTimer isValid]) {
            [theTimer invalidate];
            
            
            
        }
    }
    countLabel.text = string;
}


#pragma mark 点击按钮进入购物车界面
- (void)gotoCarts:(id)sender{
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        LogInViewController *enterVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
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

#pragma mark UIscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_currentIndex == 0) {
        scrollView.bounces = NO;
    } else{
        scrollView.bounces = YES;
    }
}

#pragma mark 左滑进入个人中心界面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((scrollView.contentInset.left < 0) && (_currentIndex == 0) && velocity.x < 0) {
        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil withObject:self];
    }
}


#pragma mark --PageViewControllerDelegate--
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    _currentIndex = [_pageContentVC indexOfObject:viewController];
    if (_currentIndex < _pageContentVC.count - 1) {
        _pageCurrentIndex = _currentIndex + 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    } else{
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    _currentIndex = [_pageContentVC indexOfObject:viewController];
    if (_currentIndex > 0) {
        _pageCurrentIndex = _currentIndex - 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    } else{
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _currentIndex  = [_pageContentVC indexOfObject:pageViewController.viewControllers[0]];
    if (completed)
    {
        NSInteger btnTag = _currentIndex + 100;
        for (int i = 100; i<104; i++) {
            if (btnTag == i) {
                UIButton *button = (UIButton *)[self.btnView viewWithTag:i];
              [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            }
            else{
                UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
            }
        }
        
       // [self sliderLabelPositonWithIndex:currentIndex withDuration:.35];
    }else
    {
        if (finished)
        {
            
            NSInteger btnTag = _currentIndex + 100;
            for (int i = 100; i<104; i++) {
                if (btnTag == i) {
                    UIButton *button = (UIButton *)[self.btnView viewWithTag:i];
                  [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
                    
                }
                else{
                    UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                    [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
                    
                }
            }
        }
    }
    
}

#pragma mark 点击按钮进入不同的专区列表。。
- (void)buttonClicked:(NSInteger)btnTag{
    _currentIndex = btnTag - 100+1;
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            UIButton *button = (UIButton *)[self.btnView viewWithTag:btnTag];
            [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        }
    }
    NSInteger index = btnTag - 100;
    BOOL state = 0;
    if (_pageCurrentIndex < index) {
        state = 1;
    }
    _pageCurrentIndex = index;
    [_pageVC setViewControllers:@[[_pageContentVC objectAtIndex:index]] direction:state?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)btnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger btnTag = button.tag;
    _currentIndex = btnTag - 100+1;
   
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        }
    }
    NSInteger index = btnTag - 100;
    BOOL state = 0;
    if (_pageCurrentIndex < index) {
        state = 1;
    }
    _pageCurrentIndex = index;
    [_pageVC setViewControllers:@[[_pageContentVC objectAtIndex:index]] direction:state?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

#pragma mark --mmNavigationDelegate--

- (void)hiddenNavigation{
    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, -44, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 112;
    cartView.frame = rect;
  

}

- (void)showNavigation{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
//    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156, 44, 44);
}

#pragma mark RootVCPushOtherVCDelegate

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}


@end