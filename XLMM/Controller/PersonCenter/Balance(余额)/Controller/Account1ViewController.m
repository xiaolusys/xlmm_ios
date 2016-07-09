//
//  Account1ViewController.m
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "Account1ViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "AccountTableViewCell.h"
#import "WithdrawCashViewController.h"
#import "AccountModel.h"
#import "SVProgressHUD.h"
#import "JMWithdrawCashController.h"

@interface Account1ViewController ()
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSString *nextPage;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)BOOL isFirstLoad;

@property (nonatomic, assign)CGFloat headerH;

@property (nonatomic, strong)UILabel *moneyLabel;

/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
/**
 *  上拉加载的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;

@end

static NSString *identifier = @"AccountCell";
@implementation Account1ViewController {
    NSMutableArray *_imageArray;
    UIView *emptyView;
}


- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel) name:@"drawCashMoeny" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"BlanceAccount"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"BlanceAccount"];
}



- (void)updateMoneyLabel{
   NSUserDefaults *drawCashM = [NSUserDefaults standardUserDefaults];
    NSString *str = [drawCashM objectForKey:@"DrawCashM"];
    self.moneyLabel.text = str;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self createNavigationBarWithTitle:@"钱包" selecotr:@selector(backBtnClicked:)];
    
    [self createRightbutton];
    [self createTableView];

    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark 数据请求
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/users/get_budget_detail", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self.dataArr removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];

}
- (void)loadMore {
    if ([self.nextPage class] == [NSNull class]) {
        [self endRefresh];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.nextPage parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
- (void)dataAnalysis:(NSDictionary *)data {
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count == 0 ) {
        [self createEmptyView];
        return;
    }
    for (NSDictionary *account in results) {
        AccountModel *accountM = [[AccountModel alloc] init];
        [accountM setValuesForKeysWithDictionary:account];
        [self.dataArr addObject:accountM];
    }
}


- (void)createRightbutton{
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20, 0, 44, 44)];
    [button1 setTitle:@"提现" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    //添加header
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREENWIDTH, 50)];
    self.moneyLabel.textColor = [UIColor orangeThemeColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:35];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [self.accountMoney floatValue]];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 75, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的余额(元)";
    
    [headerV addSubview:titleLabel];
    [headerV addSubview:self.moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    self.headerH = CGRectGetMaxY(headerV.frame);
    
    self.tableView.tableHeaderView = headerV;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
    
}

- (void)createEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AccountEmpty" owner:nil options:nil];
    emptyView = views[0];
    
    emptyView.frame = CGRectMake(0, 186, SCREENWIDTH, SCREENHEIGHT - 186);
    
    UIButton *button = (UIButton *)[emptyView viewWithTag:101];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    
    [self.view addSubview:emptyView];
    //    emptyView.hidden = YES;
}

#pragma mark --邀请好友
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


//提现
- (void)rightBarButtonAction {
    JMWithdrawCashController *drawCash = [[JMWithdrawCashController alloc] init];
    drawCash.personCenterDict = self.personCenterDict;
    
//    WithdrawCashViewController *drawCash = [[WithdrawCashViewController alloc] initWithNibName:@"WithdrawCashViewController" bundle:nil];
//    CGFloat money = [self.moneyLabel.text floatValue];
//    NSNumber *number = [NSNumber numberWithFloat:money];
//    drawCash.money = number;
    
    [self.navigationController pushViewController:drawCash animated:YES];
}

#pragma mark ---UItableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountModel *accountM = self.dataArr[indexPath.row];
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillDataOfCell:accountM];
    return cell;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end















