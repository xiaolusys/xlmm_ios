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

@interface Account1ViewController ()
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSString *nextPage;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)BOOL isFirstLoad;

@property (nonatomic, assign)CGFloat headerH;

@property (nonatomic, strong)UILabel *moneyLabel;
@end

static NSString *identifier = @"AccountCell";
@implementation Account1ViewController

{
    UIView *emptyView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel) name:@"drawCashMoeny" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}

- (void)updateMoneyLabel{
   NSUserDefaults *drawCashM = [NSUserDefaults standardUserDefaults];
    NSString *str = [drawCashM objectForKey:@"DrawCashM"];
    self.moneyLabel.text = str;
    
    //刷新记录
    [self againRequest:YES];
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
//    self.money = 0;
    
    [self createTableView];
//    if (!self.money > 0) {
//        //        [self createEmptyView];
//    }
    //    [self createEmptyView];
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
    
    [self againRequest:NO];
}

- (void)againRequest:(BOOL)type {
    if (type) {
        [self.dataArr removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/users/get_budget_detail", Root_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:   %@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取信息失败，请检查网络或重试"];
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
    
    
    [self.view addSubview:emptyView];
    //    emptyView.hidden = YES;
}

#pragma mark --邀请好友
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


//提现
- (void)rightBarButtonAction {
    WithdrawCashViewController *drawCash = [[WithdrawCashViewController alloc] initWithNibName:@"WithdrawCashViewController" bundle:nil];
    CGFloat money = [self.moneyLabel.text floatValue];
    NSNumber *number = [NSNumber numberWithFloat:money];
    drawCash.money = number;
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

#pragma mark--网络请求
- (void)dataAnalysis:(NSDictionary *)data {
    self.nextPage = data[@"next"];
    
    if (!self.isFirstLoad && !([self.nextPage class] == [NSNull class])) {
        [self addLoadMoreFooter];
    }
    
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
    [self.tableView reloadData];
}

- (void)addLoadMoreFooter {
    //添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if([self.nextPage class] == [NSNull class]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self loadMore];
    }];
}

//加载更多
- (void)loadMore {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.nextPage parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
