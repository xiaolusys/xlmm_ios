//
//  NewLeftViewController.m
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NewLeftViewController.h"
#import "PersonCenterViewController1.h"
#import "RESideMenu.h"
#import "EnterViewController.h"
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"
#import "TuihuoController.h"
#import "TuihuoViewController.h"
#import "TousuViewController.h"
#import "JifenViewController.h"
#import "YouHuiQuanViewController.h"
#import "UIImageView+WebCache.h"




@interface NewLeftViewController ()

@end

@implementation NewLeftViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneNumberLogin" object:nil];


}

- (void)phoneNumberLogin:(NSNotification *)notification{
    NSLog(@"phone number longin");
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    [self setJifenInfo];
    [self.quitButton setTitle:@"退出账号" forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    
}

- (void)updataAfterLogin:(NSNotification *)notification{
    NSLog(@"12345678909");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSDictionary *userInfo =  [userDefaults objectForKey:@"userInfo"];
    NSLog(@"userInfo = %@", userInfo);
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"headimgurl"]]];
    self.nameLabel.text = [userInfo objectForKey:@"nickname"];
    [self setJifenInfo];
    [self.quitButton setTitle:@"退出账号" forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect mainSize = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen %@", NSStringFromCGRect(mainSize));
    
    if (mainSize.size.height > 600) {

        self.headerViewHeight.constant = mainSize.size.height * 0.29f;

    } else if (mainSize.size.height > 550){
  
          self.headerViewHeight.constant = mainSize.size.height * 0.33f;
    } else {
        self.headerViewHeight.constant = mainSize.size.height * 0.35f;
        
    }
  
    self.footerViewHeight.constant = mainSize.size.height * 0.29f;
   NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSLog(@"用户信息 = %@", dic);
    
    //[self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]];
    self.nameLabel.text = @"未登录";
    NSLog(@"headviewheight = %f, footerViewHeight = %f", _headerViewHeight.constant, _footerViewHeight.constant);
    self.quitButton.layer.borderWidth = 1.0;
    self.quitButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.quitButton.layer.cornerRadius = 18.5;
    self.touxiangImage.layer.cornerRadius = 30;
    self.touxiangImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:203/255.0 blue:14/255.0 alpha:1].CGColor;
    self.touxiangImage.layer.masksToBounds = YES;
    self.touxiangImage.layer.borderWidth = 1;
    if (mainSize.size.height == 480) {
        NSLog(@"ihone 4s");
        self.topDistance.constant = 24;
        self.bottomDistance.constant = 24;
        
    }
    //[self setJifenInfo];
    [self.quitButton setTitle:@"登录" forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void)setJifenInfo{
  //  http://m.xiaolu.so/rest/v1/integral
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/integral", Root_URL];
    NSLog(@"jifen Url = %@", string);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
    NSArray *array = [dic objectForKey:@"results"];
    if (array.count != 0) {
   
        NSDictionary *results = [array objectAtIndex:0];
        
        NSLog(@"results = %@", results);
        
        self.jifenLabel.text = [NSString stringWithFormat:@"%ld", (long)[[results objectForKey:@"integral_value"] integerValue]];
    }
   
    
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

- (IBAction)jifenClicked:(id)sender {
    NSLog(@"积分");
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        JifenViewController *jifenVC = [[JifenViewController alloc] initWithNibName:@"JifenViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:jifenVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
  
    
}

- (IBAction)youhuquanClicked:(id)sender {
    NSLog(@"优惠券");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:youhuiVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
    
   
    
    
}

- (IBAction)settingClicked:(id)sender {
    NSLog(@"设置");
}

- (IBAction)suggestionClicked:(id)sender {
    NSLog(@"投诉建议");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        TousuViewController *yijianVC = [[TousuViewController alloc] initWithNibName:@"TousuViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:yijianVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
   
    
    
    
}

- (IBAction)waitPayClicked:(id)sender {
    NSLog(@"待支付");
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self.sideMenuViewController hideMenuViewController];
        
        NSLog(@"待支付");
        PersonCenterViewController1 *zhifuVC = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }

   

}

- (IBAction)waitSendClicked:(id)sender {
     NSLog(@"待收货");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        PersonCenterViewController2 *shouhuoVC = [[PersonCenterViewController2 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:shouhuoVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
    
    
}

- (IBAction)tuihuoClicked:(id)sender {
     NSLog(@"退换货");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        TuihuoViewController *tuihuoVC = [[TuihuoViewController alloc] initWithNibName:@"TuihuoViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:tuihuoVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
  
}

- (IBAction)allDingdanClicked:(id)sender {
     NSLog(@"全部订单");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        PersonCenterViewController3 *quanbuVC = [[PersonCenterViewController3 alloc] initWithNibName:@"PersonCenterViewController3" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:quanbuVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
 
}

- (IBAction)tuichuClicked:(id)sender {
    NSLog(@"退出账户");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"login"];
//    [userDefaults setObject:nil forKey:@"userInfo"];
    
    //   http://m.xiaolu.so/rest/v1/users/customer_logout
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
    NSLog(@"urlString = %@", urlString);
    
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    
    
    NSLog(@"%@",str1);
    
   
    [userDefaults synchronize];
    if ([self.quitButton.titleLabel.text  isEqual: @"登录"] ) {
        [self.sideMenuViewController hideMenuViewController];
        
        
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
    
    
//     NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    self.touxiangImageView.image = nil;
    self.nameLabel.text = @"未登录";
    self.jifenLabel.text = @"0";
    self.youhuiquanLabel.text = @"0";
    
    [self.quitButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.sideMenuViewController hideMenuViewController];
}
@end
