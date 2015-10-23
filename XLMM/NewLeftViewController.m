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


@interface NewLeftViewController ()

@end

@implementation NewLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect mainSize = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen %@", NSStringFromCGRect(mainSize));
    self.headerViewHeight.constant = mainSize.size.height * 0.297f;
    self.footerViewHeight.constant = mainSize.size.height * 0.3126f;
    
    NSLog(@"headviewheight = %f, footerViewHeight = %f", _headerViewHeight.constant, _footerViewHeight.constant);
    self.quitButton.layer.borderWidth = 1.0;
    self.quitButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.quitButton.layer.cornerRadius = 18.5;
    self.touxiangImage.layer.cornerRadius = 30;
    self.touxiangImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:203/255.0 blue:14/255.0 alpha:1].CGColor;
    self.touxiangImage.layer.masksToBounds = YES;
    self.touxiangImage.layer.borderWidth = 2;
    if (mainSize.size.height == 480) {
        NSLog(@"ihone 4s");
        self.topDistance.constant = 24;
        self.bottomDistance.constant = 24;
        
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
    
    [userDefaults synchronize];
    
    
    
    [self.sideMenuViewController hideMenuViewController];
}
@end
