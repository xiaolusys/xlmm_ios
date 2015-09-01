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



@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (strong, readwrite, nonatomic) UITableView *tableView;

@end



@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //  Do any additional setup after loading the view from its nib.
   
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            
            
           // [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOFirstViewController alloc] init]]
                    //                                     animated:YES];
           // [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
           // [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]]
                  //                                       animated:YES];
           // [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            
            
            break;
        case 3:
            
            
            break;
        case 4:
            
            
            break;
        case 5:
            
            
            break;
        case 6:
            
            
            break;
        case 7:
            
            
            break;
           case 8:
            
            
            break;
        case 9:
            
            
            break;
        case 10:
            
            
            break;
        case 11:
            
            
            break;
        default:
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
    
    NSArray *titles = @[@"带支付", @"待收获", @"全部订单", @"优惠券", @"我的积分",@"地址管理", @"我的退货（款）", @"密码修改", @"投诉建议", @"切换账号",@"退出"];
    NSArray *images = @[@"icon-daizhifu.png", @"icon-daishouhuo.png", @"icon-quanbudingdan.png", @"icon-youhuiquan.png", @"icon-wodejifen.png", @"icon-dizhiguanli.png", @"icon-tuihuanhuo.png",@"icon-mimaxiugai.png",@"icon-tousujianyi.png",@"icon-qiehuanzhanghao.png",@""];
    cell.nameLabel.text = titles[indexPath.row];
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.myImageView.image = [UIImage imageNamed:images[indexPath.row]];
    
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
