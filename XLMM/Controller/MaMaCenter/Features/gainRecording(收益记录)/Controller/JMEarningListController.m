//
//  JMEarningListController.m
//  XLMM
//
//  Created by zhang on 17/3/24.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMEarningListController.h"
#import "JMEarningRecordTableView.h"
#import "JMEarningModel.h"
#import "JMReloadEmptyDataView.h"
#import "JMEarningRecordCell.h"

@interface JMEarningListController () <UITableViewDelegate, UITableViewDataSource, CSTableViewPlaceHolderDelegate> {
    BOOL _isLoadMore;
    BOOL _isPullDown;
    NSString *_nextUrlString;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *currentDataDic;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
@property (nonatomic, strong) UILabel *valueLabel;


@end

@implementation JMEarningListController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableDictionary *)currentDataDic {
    if (!_currentDataDic) {
        _currentDataDic = [NSMutableDictionary dictionary];
    }
    return _currentDataDic;
}


#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMEarningListController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMEarningListController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"收益记录" selecotr:@selector(backClick)];
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JMEarningRecordCell class] forCellReuseIdentifier:@"JMEarningRecordCellIdentifier"];
    [self.view addSubview:self.tableView];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *valueLabel = [UILabel new];
    [sectionView addSubview:valueLabel];
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel.font = [UIFont systemFontOfSize:40.];
    self.valueLabel = valueLabel;
    
    UILabel *titleLabel = [UILabel new];
    [sectionView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.text = @"累计收益";
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(sectionView).offset(20);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(valueLabel.mas_bottom).offset(10);
    }];
    
    self.tableView.tableHeaderView = sectionView;
    
    
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    //    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [self loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    //    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadMore];
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

#pragma mark 网络请求,数据处理
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mmcarry",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self.dataSource removeAllObjects];
        [self.currentDataDic removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextUrlString]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)dic {
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",([dic[@"total"] floatValue] / 100.f)];
    _nextUrlString = dic[@"next"];
    NSArray *results = dic[@"results"];
    if (results.count > 0) {
        for (NSDictionary *dict in results) {
            JMEarningModel *model = [JMEarningModel mj_objectWithKeyValues:dict];
            NSString *date = [self dateDeal:model.created];
            self.dataSource = [[self.currentDataDic allKeys] mutableCopy];
            if ([self.dataSource containsObject:date]) {
                NSMutableArray *orderArr = self.currentDataDic[date];
                [orderArr addObject:model];
            }else {
                NSMutableArray *orderArr = [NSMutableArray array];
                [orderArr addObject:model];
                [self.currentDataDic setObject:orderArr forKey:date];
            }
        }
        self.dataSource = [[self.currentDataDic allKeys] mutableCopy];
        self.dataSource = [self sortAllKeyArray:self.dataSource];
    }
    // 刷新 数据
    [self.tableView cs_reloadData];
    
}
#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = self.dataSource[section];
    return [self.currentDataDic[key] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JMEarningRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMEarningRecordCellIdentifier"];
    if (!cell) {
        cell = [[JMEarningRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JMEarningRecordCellIdentifier"];
    }
    NSString *key = self.dataSource[indexPath.section];
    JMEarningModel *model = self.currentDataDic[key][indexPath.row];
    [cell configEarningModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    sectionView.backgroundColor = [UIColor lineGrayColor];
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:14.];
    timeLabel.textColor = [UIColor buttonTitleColor];
    [sectionView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(10);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    if (self.dataSource.count == 0) {
        return sectionView;
    }
    NSString *key = self.dataSource[section];
    NSMutableArray *orderArr = self.currentDataDic[key];
    JMEarningModel *model = [orderArr firstObject];
    timeLabel.text = [NSString yearDeal:model.created];
    return sectionView;
}



- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有收益哦!" DescTitle:@"快去赚取吧~!" ButtonTitle:@"快去赚取" Image:@"emptyJifenIcon" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}


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
- (NSString *)dateDeal:(NSString *)str {
    NSString *deleYear = [NSString yearDeal:str];
    NSString *date = [deleYear stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return date;
}







- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end

















































































