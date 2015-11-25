//
//  PersonCenterViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterViewController1.h"
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"
#import "YouHuiQuanViewController.h"
#import "AddressViewController.h"
#import "TousuViewController.h"
#import "EnterViewController.h"
#import "SetPasswordViewController.h"
#import "JifenViewController.h"




#import "MMClass.h"

@interface PersonCenterViewController ()
{
    BOOL islogin;
}

@end

@implementation PersonCenterViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL islogIn = [userDefaults boolForKey:kIsLogin];
    if (islogIn) {
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
        self.scoreLabel.text = @"";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
    _screenWidth.constant = SCREENWIDTH;
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = @"个人中心";
    navLabel.textColor = [UIColor colorWithR:60 G:60 B:60 alpha:1];
    navLabel.font = [UIFont boldSystemFontOfSize:30];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 42, 39);
    [rightButton setBackgroundImage:LOADIMAGE(@"icon-shouye.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 42, 39);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated{
    self.virticalSpace.constant = 0;

    [super viewDidDisappear:animated];
}

- (void)backClicked:(UIButton *)button{
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




- (IBAction)button1Clicked:(id)sender {
    NSLog(@"heoo");
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
    PersonCenterViewController1 *person1VC = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil];
    [self.navigationController pushViewController:person1VC animated:YES];
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];

    }
}

- (IBAction)button2Clicked:(id)sender {
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
    NSLog(@"222");
    PersonCenterViewController2 *person2VC = [[PersonCenterViewController2 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
    [self.navigationController pushViewController:person2VC animated:YES];
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }

}

- (IBAction)button3Clicked:(id)sender {
    NSLog(@"333");
    
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        NSLog(@"222");
        PersonCenterViewController3 *person3VC = [[PersonCenterViewController3 alloc] initWithNibName:@"PersonCenterViewController3" bundle:nil];
        [self.navigationController pushViewController:person3VC animated:YES];
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
}

- (IBAction)btn1Clicked:(id)sender {
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        MMLOG(@"btn1");
        YouHuiQuanViewController *youHuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        [self.navigationController pushViewController:youHuiVC animated:YES];
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }


    
}

- (IBAction)btn2Clicked:(id)sender {
    MMLOG(@"btn2");
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        MMLOG(@"btn1");
        JifenViewController *jiFenVC = [[JifenViewController alloc] initWithNibName:@"JifenViewController" bundle:nil];
        [self.navigationController pushViewController:jiFenVC animated:YES];
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }


}

- (IBAction)btn3Clicked:(id)sender {
    
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        [self.navigationController pushViewController:addressVC animated:YES];
        
        MMLOG(@"btn3");
        
           } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }


}

- (IBAction)btn4Clicked:(id)sender {
    MMLOG(@"btn4");

}

- (IBAction)btn5Clicked:(id)sender {
    MMLOG(@"btn5");
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        SetPasswordViewController *setPasswordVC = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:setPasswordVC animated:YES];
        
        
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
    
 

}

- (IBAction)btn6Clicked:(id)sender {
    MMLOG(@"btn6");
    NSUserDefaults *userfaults = [NSUserDefaults standardUserDefaults];
    islogin = [userfaults boolForKey:kIsLogin];
    if (islogin) {
        TousuViewController *tousuVC = [[TousuViewController alloc] initWithNibName:@"TousuViewController" bundle:nil];
        [self.navigationController pushViewController:tousuVC animated:YES];

        
        
    } else {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
    
   

}
- (IBAction)btn7Clicked:(id)sender {
    MMLOG(@"btn7");

}

- (IBAction)gobackClicked:(id)sender{
    NSLog(@"退出");
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end
