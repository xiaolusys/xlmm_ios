//
//  AccountViewController.m
//  XLMM
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "AccountViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "AccountTableViewCell.h"
#import "WithdrawCashViewController.h"


@interface AccountViewController ()
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSString *nextPage;

@property (nonatomic, assign)CGFloat headerH;

@end

static NSString *identifier = @"AccountCell";
@implementation AccountViewController
{
    UIView *emptyView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavigationBarWithTitle:@"钱包" selecotr:@selector(backBtnClicked:)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    [button1 setTitle:@"提现" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBarHidden = NO;
    self.money = 0;
    
    [self createTableView];
    if (!self.money > 0) {
        [self createEmptyView];
    }
//    [self createEmptyView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    
    [self.view addSubview:self.tableView];
    
    //添加header
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREENWIDTH, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = @"0.00";
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 75, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的余额(元)";
    
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    self.headerH = CGRectGetMaxY(headerV.frame);
    
    self.tableView.tableHeaderView = headerV;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
    
    //添加上拉加载
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if([self.nextPage class] == [NSNull class]) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            return ;
//        }
////        [self loadMore];
//    }];
    
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/shopping", Root_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
//        [self dataAnalysis:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:   %@", error);
    }];
}

- (void)createEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AccountEmpty" owner:nil options:nil];
    emptyView = views[0];
    
    emptyView.frame = CGRectMake(0, 186, SCREENWIDTH, SCREENHEIGHT - 186);
    
    UIButton *button = (UIButton *)[emptyView viewWithTag:101];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoInviteFriends) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:emptyView];
//    emptyView.hidden = YES;
}

#pragma mark --邀请好友
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoInviteFriends {
    
}

//提现
- (void)rightBarButtonAction {
    WithdrawCashViewController *drawCash = [[WithdrawCashViewController alloc] initWithNibName:@"WithdrawCashViewController" bundle:nil];
    [self.navigationController pushViewController:drawCash animated:YES];
}

#pragma mark ---UItableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataDic.count;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSString *key = self.dataArr[section];
//    NSMutableArray *orderArr = self.dataDic[key];
//    return orderArr.count;
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *key = self.dataArr[indexPath.section];
//    NSMutableArray *orderArr = self.dataDic[key];
//    MaMaOrderModel *orderM = orderArr[indexPath.row];
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    [cell fillDataOfCell:orderM];
//    return cell;
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