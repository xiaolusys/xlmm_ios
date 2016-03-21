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
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"
#import "TuihuoViewController.h"
#import "TousuViewController.h"
#import "JifenViewController.h"
#import "YouHuiQuanViewController.h"
#import "UIImageView+WebCache.h"
#import "MMUserCoupons.h"

#import "AddressViewController.h"
#import "SettingViewController.h"
#import "LogInViewController.h"
#import "Account1ViewController.h"
#import "PersonOrderViewController.h"
#import "UIColor+RGBColor.h"

#import "AFHTTPRequestOperationManager.h"

@interface NewLeftViewController ()
@property (nonatomic, strong)NSNumber *accountMoney;
@end

@implementation NewLeftViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel) name:@"drawCashMoeny" object:nil];
}

- (void)setUserInfo{
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin) {
        // http://m.xiaolu.so/rest/v1/users/profile
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!responseObject) return;
            [self updateUserInfo:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}

- (void)updateUserInfo:(NSDictionary *)dic {
    NSString *nickName = [dic objectForKey:@"nick"];
    if (nickName.length >= 4) {
        self.nameLabel.text = [dic objectForKey:@"nick"];
    }
    self.jifenLabel.text = [[dic objectForKey:@"score"] stringValue];
    //判断是否为0
    if ([[dic objectForKey:@"user_budget"] class] == [NSNull class]) {
        self.accountLabel.text  = [NSString stringWithFormat:@"0.00"];
        self.accountMoney = [NSNumber numberWithFloat:0.00];
    }else {
        NSDictionary *xiaolumeimei = [dic objectForKey:@"user_budget"];
        NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
        self.accountLabel.text  = [NSString stringWithFormat:@"%.2f", [num floatValue]];
        self.accountMoney = num;
    }
    
    //优惠券，待支付，待收货，退换货
    self.youhuiquanLabel.text = [NSString stringWithFormat:@"%@", dic[@"coupon_num"]];
    
    if ([dic[@"waitpay_num"] integerValue] == 0) {
        self.waitPayNum.hidden = YES;
    }else {
        self.waitPayNum.hidden = NO;
        self.waitPayNum.layer.cornerRadius = 10;
        self.waitPayNum.layer.masksToBounds = YES;
        self.waitPayNum.backgroundColor = [UIColor orangeThemeColor];
        self.waitPayNum.text = [NSString stringWithFormat:@"%@", dic[@"waitpay_num"]];
    }
    if ([dic[@"waitgoods_num"] integerValue] == 0) {
        self.waitReceiveNum.hidden = YES;
    }else {
        self.waitReceiveNum.hidden = NO;
        self.waitReceiveNum.layer.cornerRadius = 10;
        self.waitReceiveNum.layer.masksToBounds = YES;
        self.waitReceiveNum.backgroundColor = [UIColor orangeThemeColor];
        self.waitReceiveNum.text = [NSString stringWithFormat:@"%@", dic[@"waitgoods_num"]];
    }
    
    if ([dic[@"refunds_num"] integerValue] == 0) {
        self.exchangeNum.hidden = YES;
    }else {
        self.exchangeNum.hidden = NO;
        self.exchangeNum.layer.cornerRadius = 10;
        self.exchangeNum.layer.masksToBounds = YES;
        self.exchangeNum.backgroundColor = [UIColor orangeThemeColor];
        self.exchangeNum.text = [NSString stringWithFormat:@"%@", dic[@"refunds_num"]];
    }

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneNumberLogin" object:nil];
}

- (void)phoneNumberLogin:(NSNotification *)notification{
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
//    [self setJifenInfo];
//    [self setYHQInfo];
    [self setUserInfo];
    [self.quitButton setTitle:@"退出账号" forState:UIControlStateNormal];
}

- (void)setImage{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    
}

- (void)updataAfterLogin:(NSNotification *)notification{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSDictionary *userInfo =  [userDefaults objectForKey:@"userInfo"];
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"headimgurl"]]];
    self.nameLabel.text = [userInfo objectForKey:@"nickname"];
    [self setUserInfo];
    [self.quitButton setTitle:@"退出账号" forState:UIControlStateNormal];
}

//- (void)setYHQInfo{
//    MMUserCoupons *coupons = [[MMUserCoupons alloc] init];
//    self.youhuiquanLabel.text = [NSString stringWithFormat:@"%ld", (long)coupons.couponValue];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect mainSize = [UIScreen mainScreen].bounds;
    
    if (mainSize.size.height > 600) {

        self.headerViewHeight.constant = mainSize.size.height * 0.29f;

    } else if (mainSize.size.height > 550){
  
          self.headerViewHeight.constant = mainSize.size.height * 0.33f;
    } else {
        self.headerViewHeight.constant = mainSize.size.height * 0.35f;
        
    }
  
    self.footerViewHeight.constant = mainSize.size.height * 0.29f;
  __unused NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    //[self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]];
    self.nameLabel.text = @"未登录";
//    NSLog(@"headviewheight = %f, footerViewHeight = %f", _headerViewHeight.constant, _footerViewHeight.constant);
    self.quitButton.layer.borderWidth = 1.0;
    self.quitButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.quitButton.layer.cornerRadius = 18.5;
    self.touxiangImage.layer.cornerRadius = 30;
    self.touxiangImage.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
    self.touxiangImage.layer.masksToBounds = YES;
    self.touxiangImage.layer.borderWidth = 1;
    if (mainSize.size.height == 480) {
        NSLog(@"ihone 4s");
        self.topDistance.constant = 24;
        self.bottomDistance.constant = 24;
        
    }
    //[self setJifenInfo];
  
    
    
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginMethod];
    
  //  NSLog(@"login: %@", string);
    if ([string isEqualToString:kWeiXinLogin]) {
        //
        [self updataAfterLogin:nil];
    } else if ([string isEqualToString:kPhoneLogin]) {
        //
        [self phoneNumberLogin:nil];
        
    }
    
    
    
  //  self.yuelabel.text = @"100.0 0";
    
    
}

- (void)setJifenInfo{
  //  http://m.xiaolu.so/rest/v1/integral
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/integral", Root_URL];
//    NSLog(@"jifen Url = %@", string);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        self.jifenLabel.text = @"0";
        
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"dic = %@", dic);
    NSArray *array = [dic objectForKey:@"results"];
    if (array.count != 0) {
   
        NSDictionary *results = [array objectAtIndex:0];
        
       // NSLog(@"results = %@", results);
        
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
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        JifenViewController *jifenVC = [[JifenViewController alloc] initWithNibName:@"JifenViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:jifenVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
  
    
}

- (IBAction)youhuquanClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:youhuiVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
    
    
   
    
    
}

- (IBAction)yueClicked:(id)sender {
    
    NSLog(@"查看余额详情");
}

- (IBAction)settingClicked:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        SettingViewController *addressVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:addressVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
}

- (IBAction)suggestionClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        TousuViewController *yijianVC = [[TousuViewController alloc] initWithNibName:@"TousuViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:yijianVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
    
   
    
    
    
}

- (IBAction)waitPayClicked:(id)sender {
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self.sideMenuViewController hideMenuViewController];
        
//        PersonCenterViewController1 *zhifuVC = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil];
        
        PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
        order.index = 101;
//        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:order];
        }
        
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }

   

}

- (IBAction)waitSendClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//        PersonCenterViewController2 *shouhuoVC = [[PersonCenterViewController2 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
        
        PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
        order.index = 102;
        
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:order];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
    
    
    
}

- (IBAction)tuihuoClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        TuihuoViewController *tuihuoVC = [[TuihuoViewController alloc] initWithNibName:@"TuihuoViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:tuihuoVC];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        
        [self displayLoginView];
        return;
    }
    
  
}

- (IBAction)allDingdanClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//        PersonCenterViewController3 *quanbuVC = [[PersonCenterViewController3 alloc] initWithNibName:@"PersonCenterViewController3" bundle:nil];
        
        PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
        order.index = 100;
        
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:order];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        [self displayLoginView];
        return;
    }
    
 
}

- (IBAction)tuichuClicked:(id)sender {
   
    
    if ([self.quitButton.titleLabel.text isEqualToString:@"登录"] ) {
        [self.sideMenuViewController hideMenuViewController];
        [self displayLoginView];
        return;
    }
    if ([self.quitButton.titleLabel.text isEqualToString:@"退出账号"]) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"login"];
        [userDefaults setObject:@"unlogin" forKey:kLoginMethod];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];

        
        
        
        //   http://m.xiaolu.so/rest/v1/users/customer_logout
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
       // NSLog(@"urlString = %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];  
        
        //第二步，创建请求
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        __unused NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
       // NSLog(@"%@",str1);
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:@{@"alterView":alterView} repeats:NO];

        [alterView show];
    }


//     NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    self.touxiangImageView.image = nil;
    self.nameLabel.text = @"未登录";
    self.jifenLabel.text = @"0";
    self.youhuiquanLabel.text = @"0";
    self.accountLabel.text = @"0.00";
    
    self.waitPayNum.hidden = YES;
    self.waitReceiveNum.hidden = YES;
    self.exchangeNum.hidden = YES;
    
    [self.quitButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.sideMenuViewController hideMenuViewController];
}

-(void) performDismiss:(NSTimer *)timer
{
    UIAlertView *Alert = [timer.userInfo objectForKey:@"alterView"];
    [Alert dismissWithClickedButtonIndex:0 animated:NO];
}



- (IBAction)loginButtonClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        SettingViewController *addressVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:addressVC];
        }
        [self.sideMenuViewController hideMenuViewController];
        
    }else{
        [self.sideMenuViewController hideMenuViewController];
        [self displayLoginView];
    }
    
}

- (IBAction)accountBtnAction:(id)sender {
//    AccountViewController *account = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
//    return;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//        Account1ViewController *account = [[Account1ViewController alloc] initWithNibName:@"Account1ViewController" bundle:nil];
        Account1ViewController *account = [[Account1ViewController alloc] init];
        account.accountMoney = self.accountMoney;
        
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:account];
        }
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
        [self.sideMenuViewController hideMenuViewController];
        
        [self displayLoginView];
        return;
    }
}

- (void) displayLoginView{
    LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    // zhifuVC.menuDelegate = ;
    if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
        [self.pushVCDelegate rootVCPushOtherVC:loginVC];
    }
}

- (void)updateMoneyLabel {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"DrawCashM"];
    self.accountLabel.text = str;
}
@end
