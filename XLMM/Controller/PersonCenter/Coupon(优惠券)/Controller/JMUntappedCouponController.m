//
//  JMUntappedCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUntappedCouponController.h"
#import "JMCouponModel.h"
#import "JMCouponRootCell.h"
#import "JMEmptyView.h"
#import "JMReloadEmptyDataView.h"
#import "CSTableViewPlaceHolderDelegate.h"
#import "JMCouponController.h"
//#import "JMSelecterButton.h"


@interface JMUntappedCouponController ()<UITableViewDataSource,UITableViewDelegate,CSTableViewPlaceHolderDelegate> {
    NSString *_urlStr;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JMCouponModel *couponModel;
@property (nonatomic, assign) BOOL isPopToRootView;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMUntappedCouponController

#pragma 懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
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
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMUserCouponController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMUserCouponController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabelView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.dataSource removeAllObjects];
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"优惠券加载失败,请稍后重试~!"];
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_urlStr]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData:(NSDictionary *)couponData {
    _urlStr = couponData[@"next"];
    NSArray *resultsArr = couponData[@"results"];
    NSString *statusStr = self.itemArr[self.segmentIndex];
    if ([statusStr rangeOfString:@"("].location == NSNotFound) {
        statusStr = [NSString stringWithFormat:@"%@(%ld)",statusStr,[couponData[@"count"] integerValue]];
        self.itemArr[self.segmentIndex] = statusStr;
        self.payCouponVC.segmentSectionTitle = [self.itemArr copy];
    }
    
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMCouponModel *model = [JMCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.tableView cs_reloadData];
}

- (void)createTabelView {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 110;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMCouponController";
    JMCouponRootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMCouponRootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.couponModel = self.dataSource[indexPath.row];
    [cell configData:self.couponModel Index:self.couponStatus];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"emptyYouhuiquanIcon" ReloadBlcok:^{
            self.isPopToRootView = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

@end
































