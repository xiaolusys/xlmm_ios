//
//  LeftMenuViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "MMClass.h"
#import "PersonTableCell.h"

#import "PersonCenterViewController1.h"
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"

#import "YouHuiQuanViewController.h"
#import "AddressViewController.h"
#import "SetPasswordViewController.h"
#import "TousuViewController.h"
#import "LogInViewController.h"
#import "JifenViewController.h"

#import "TuihuoViewController.h"

#import "EnterViewController.h"





@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (strong, readwrite, nonatomic) UITableView *tableView;

@end



@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //  Do any additional setup after loading the view from its nib.
   
    self.view.backgroundColor = [UIColor colorWithR:38 G:38 B:46 alpha:1];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, SCREENHEIGHT - 80) style:UITableViewStylePlain];
     //   tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
      //  tableView.backgroundColor = [UIColor redColor];
      //  tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
       // tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
 
//    [UIColor darkGrayColor];
}


#pragma mark -
#pragma mark UITableView Delegate


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    backView.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
    
    cell.selectedBackgroundView = backView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    backView.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
    
    cell.selectedBackgroundView = backView;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        
    }else{
        
        [self.sideMenuViewController hideMenuViewController];

         
        EnterViewController *zhifuVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        // zhifuVC.menuDelegate = ;
        if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
            [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
        }
        return;
    }
    
    
    
    switch (indexPath.row) {
        case 0:
        {
            
            [self.sideMenuViewController hideMenuViewController];

           PersonCenterViewController1 *zhifuVC = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil];
           // zhifuVC.menuDelegate = ;
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:zhifuVC];
            }

//
        }
            
           // break;
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOFirstViewController alloc] init]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
        {
            PersonCenterViewController2 *shouhuoVC = [[PersonCenterViewController2 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:shouhuoVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
//            PersonCenterViewController2 *shouhuoVC = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
//            //            [self.navigationController pushViewController:zhifuVC animated:YES];
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:zhifuVC] animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//           // [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]]
//                  //                                       animated:YES];
//           // [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:{
            
            PersonCenterViewController3 *quanbuVC = [[PersonCenterViewController3 alloc] initWithNibName:@"PersonCenterViewController3" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:quanbuVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 3:{
            YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
            youhuiVC.isSelectedYHQ = NO;
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:youhuiVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 4:{
            
            JifenViewController *jifenVC = [[JifenViewController alloc] initWithNibName:@"JifenViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:jifenVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
            
        }
            
            
            break;
        case 5:{
            AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:addressVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 6:{
            TuihuoViewController *tuihuoVC = [[TuihuoViewController alloc] initWithNibName:@"TuihuoViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:tuihuoVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 7:{
            SetPasswordViewController *setPasswordVC = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:setPasswordVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 8:{
            TousuViewController *yijianVC = [[TousuViewController alloc] initWithNibName:@"TousuViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:yijianVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 9:{
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            if (self.pushVCDelegate && [self.pushVCDelegate respondsToSelector:@selector(rootVCPushOtherVC:)]) {
                [self.pushVCDelegate rootVCPushOtherVC:loginVC];
            }
            [self.sideMenuViewController hideMenuViewController];
            
        }
            
            
            break;
        case 10:{
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:@"login"];
            
            [userDefaults synchronize];

           
            
            [self.sideMenuViewController hideMenuViewController];
            
            
            
            

        }
            
            
            break;
        default:{
            
        }
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"personCell";
    
    PersonTableCell *cell = (PersonTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        //cell = [[PersonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[PersonTableCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    }
    
    NSArray *titles = @[@"待支付", @"待收货", @"全部订单", @"优惠券", @"我的积分",@"地址管理", @"我的退货（款）", @"密码修改", @"投诉建议", @"切换账号",@"退出"];
    NSArray *images = @[@"icon-daizhifu.png", @"icon-daishouhuo.png", @"icon-quanbudingdan.png", @"icon-youhuiquan.png", @"icon-wodejifen.png", @"icon-dizhiguanli.png", @"icon-tuihuanhuo.png",@"icon-mimaxiugai.png",@"icon-tousujianyi.png",@"icon-qiehuanzhanghao.png",@""];
    cell.nameLabel.text = titles[indexPath.row];
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor colorWithR:38 G:38 B:46 alpha:1];
    cell.myImageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithR:249 G:158 B:0 alpha:1];
    return cell;
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

@end
