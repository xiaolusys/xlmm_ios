//
//  MaMaOrderListViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaOrderListViewController.h"
#import "MaMaOrderModel.h"
#import "CarryLogHeaderView.h"
#import "JMMaMaOrderListCell.h"
#import "JMQueryLogInfoController.h"


@interface MaMaOrderListViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

@property (nonatomic, strong)NSString *nextPage;

@property (nonatomic,strong) UIButton *topButton;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@end

@implementation MaMaOrderListViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"MaMaOrderListViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"MaMaOrderListViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"订单列表" selecotr:@selector(backClickAction)];
    
    [self createTableView];
    [self createButton];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDate];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    //添加header
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 25, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单记录";
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREENWIDTH, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = self.orderRecord;
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    self.tableView.tableHeaderView = headerV;
//    self.tableView.estimatedRowHeight = 80;

}
#pragma mark ---数据处理
- (void)dataAnalysis:(NSDictionary *)data {
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count == 0) { // 空视图
        
    }else {
        for (NSDictionary *order in results) {
            MaMaOrderModel *orderM = [MaMaOrderModel mj_objectWithKeyValues:order];
            NSString *date = [self dateDeal:orderM.date_field];
            self.dataArr = [[self.dataDic allKeys] mutableCopy];
            //判断对应键值的数组是否存在
            if ([self.dataArr containsObject:date]) {
                NSMutableArray *orderArr = self.dataDic[date];
                [orderArr addObject:orderM];
            }else {
                NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
                [orderArr addObject:orderM];
                [self.dataDic setObject:orderArr forKey:date];
            }
        }
        self.dataArr = [[self.dataDic allKeys] mutableCopy];
        self.dataArr = [self sortAllKeyArray:self.dataArr];
    }
    
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
//    NSArray *strarray = [str componentsSeparatedByString:@"T"];
//    NSString *year = strarray[0];
    NSString *date = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return date;
}

//将所有的key排序
- (NSMutableArray *)sortAllKeyArray:(NSMutableArray *)keyArr {
    for (int i = 0; i < keyArr.count; i++) {
        for (int j = 0; j < keyArr.count - i - 1; j++) {
            if ([keyArr[j] intValue] < [keyArr[j + 1] intValue]) {
                NSNumber *temp = keyArr[j + 1];
                keyArr[j + 1] = keyArr[j];
                keyArr[j] = temp;
            }
        }
    }
    return keyArr;
}
#pragma mark -- 请求数据
- (void)loadDate {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/mama/ordercarry?carry_type=direct",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataArr removeAllObjects];
        [self.dataDic removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
//加载更多
- (void)loadMore {
    if ([NSString isStringEmpty:self.nextPage]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextPage WithParaments:nil WithSuccess:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

#pragma mark ---UItableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.dataArr[section];
    NSMutableArray *orderArr = self.dataDic[key];
    return orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MaMaOrder";
    JMMaMaOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMMaMaOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *orderArr = self.dataDic[key];
    MaMaOrderModel *orderM = orderArr[indexPath.row];

    [cell fillDataOfCell:orderM];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//刷新行
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [self.tableView reloadData];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
    CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30); 
    //计算金额
    NSString *key = self.dataArr[section];
    NSMutableArray *orderArr = self.dataDic[key];
    MaMaOrderModel *orderM = [orderArr firstObject];
    
    [headerV yearLabelAndTotalMoneyLabelText:orderM.date_field total:[NSString stringWithFormat:@"%.2f", [orderM.today_carry floatValue]]];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *orderArr = self.dataDic[key];
    MaMaOrderModel *orderM = orderArr[indexPath.row];
    NSLog(@"%@",[orderM mj_keyValues]);
    BOOL isComanyCode = [NSString isStringEmpty:orderM.company_code];
    BOOL isPacketId = [NSString isStringEmpty:orderM.packetid];
    if (isComanyCode || isPacketId) {
        
    }else {
        JMQueryLogInfoController *loginfoVC = [[JMQueryLogInfoController alloc] init];
        loginfoVC.packetId = orderM.packetid;
        loginfoVC.companyCode = orderM.company_code;
        loginfoVC.logName = orderM.company_code;
        [self.navigationController pushViewController:loginfoVC animated:YES];
    }

}

#pragma mark 返回顶部  image == >backTop
- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}
#pragma mark -- 添加滚动的协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}


@end














































