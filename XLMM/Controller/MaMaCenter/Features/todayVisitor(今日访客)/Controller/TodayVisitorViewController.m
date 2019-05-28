//
//  TodayVisitorViewController.m
//  XLMM
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TodayVisitorViewController.h"
#import "JMFetureFansCell.h"
#import "JMVisitorModel.h"

@interface TodayVisitorViewController () {
    NSInteger VisitorNum;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *nextPage;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TodayVisitorViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TodayVisitorViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"TodayVisitorViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //http://192.168.1.13:8000/rest/v2/mama/visitor?from=3
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"今日访客" selecotr:@selector(backClicked:)];
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    UILabel *descLabel = [UILabel new];
    descLabel.textColor = [UIColor buttonTitleColor];
    descLabel.text = @"最近访客记录";
    descLabel.font = [UIFont systemFontOfSize:14.];
    [headerView addSubview:descLabel];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:36.];
    [headerView addSubview:self.titleLabel];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(20);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(10);
        make.centerX.equalTo(descLabel.mas_centerX);
    }];
    
    
    
    
}
#pragma mark -- 请求数据
- (void)loadDate {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/mama/visitor?recent=%@",Root_URL,self.visitorDate];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataArray removeAllObjects];
        [self.dataDic removeAllObjects];
        [self fetchedData:responseObject];
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
        [self fetchedData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
//- (void)downloadData:(BOOL)type{
//    NSString *str = nil;
//    if (type) {
////        str = [NSString stringWithFormat:@"%@/rest/v2/mama/visitor?from=%ld", Root_URL, (long)[self.visitorDate integerValue]];
//        str = [NSString stringWithFormat:@"%@/rest/v2/mama/visitor?recent=%@", Root_URL, self.visitorDate];
//    }else {
//        str = self.nextPage;
//    }
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject)return;
//        [self fetchedData:responseObject];
//    } WithFail:^(NSError *error) {
//        
//    } Progress:^(float progress) {
//        
//    }];
//}


- (void)fetchedData:(NSDictionary *)dic{
    VisitorNum = [dic[@"count"] integerValue];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",VisitorNum];
    self.nextPage = dic[@"next"];
    NSArray *array = dic[@"results"];
    if (array.count == 0) { // 空视图
        
    }else {
        for (NSDictionary *dic in array) {
            JMVisitorModel *visitorM = [JMVisitorModel mj_objectWithKeyValues:dic];
            NSString *data = [self dateDeal:visitorM.created];
            self.dataArray = [[self.dataDic allKeys] mutableCopy];
            //判断对应的键值数组是否存在
            if ([self.dataArray containsObject:data]) {
                NSMutableArray *visitorArr = self.dataDic[data];
                [visitorArr addObject:visitorM];
            }else {
                NSMutableArray *visitorArr = [NSMutableArray arrayWithCapacity:0];
                [visitorArr addObject:visitorM];
                [self.dataDic setObject:visitorArr forKey:data];
            }
        }
        self.dataArray = [[self.dataDic allKeys] mutableCopy];
        self.dataArray = [self sortAllKeyArray:self.dataArray];
    }
}

- (NSString *)dateDeal:(NSString *)str {
    NSString *year = [NSString yearDeal:str];
    NSString *date = [year stringByReplacingOccurrencesOfString:@"-" withString:@""];
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


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataDic allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.dataArray[section];
    NSMutableArray *visitorArr = self.dataDic[key];
    return visitorArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [UIView new];
    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
    headerV.backgroundColor = [UIColor countLabelColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 30)];
    [headerV addSubview:label];
    label.textColor = [UIColor buttonTitleColor];
    label.font = [UIFont systemFontOfSize:14.];
    
    NSString *key = self.dataArray[section];
    NSMutableArray *orderArr = self.dataDic[key];
    JMVisitorModel *visitorM = [orderArr firstObject];
    label.text = [self yearDeal:visitorM.created];

    return headerV;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMFetureFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FensiCell"];
    if (cell == nil) {
        cell = [[JMFetureFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FensiCell"];
    }
    NSString *key = self.dataArray[indexPath.section];
    NSMutableArray *orderArr = self.dataDic[key];
    JMVisitorModel *model = orderArr[indexPath.row];
    
    [cell fillVisitorData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    
}

//只含有年月日
- (NSString *)yearDeal:(NSString *)str {
    NSArray *strarray = [str componentsSeparatedByString:@"T"];
    NSString *year = strarray[0];
    return year;
}








@end


















































