//
//  JMRefundBaseController.m
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundBaseController.h"
#import "JMRefundBaseCell.h"
#import "JMRefundModel.h"
#import "RefundDetailsViewController.h"
#import "JMReloadEmptyDataView.h"
#import "JMRefundDetailController.h"

@interface JMRefundBaseController ()<UITableViewDelegate,UITableViewDataSource,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;


/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
/**
 *  上拉加载的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isPopToRootView;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

@implementation JMRefundBaseController {
    NSString *_nextPage;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"退款退货" selecotr:@selector(backClick:)];

    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[JMRefundBaseCell class] forCellReuseIdentifier:JMRefundBaseCellIdentifier];
    
}
#pragma mark 刷新界面
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
#pragma mark 数据请求
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self fetchedRefundData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPage]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPage WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self fetchedRefundData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchedRefundData:(NSDictionary *)data {
    _nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count != 0 ) {
        for (NSDictionary *refund in results) {
            JMRefundModel *refundModel = [JMRefundModel mj_objectWithKeyValues:refund];
            [self.dataSource addObject:refundModel];
        }
    }
    [self.tableView cs_reloadData];
}
#pragma mark ---UItableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMRefundBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:JMRefundBaseCellIdentifier];
    if (!cell) {
        cell = [[JMRefundBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMRefundBaseCellIdentifier];
    }
    JMRefundModel *refundModel = self.dataSource[indexPath.row];
    
    [cell configRefund:refundModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMRefundModel *refundModel = self.dataSource[indexPath.row];
    JMRefundDetailController *refundDetailVC = [[JMRefundDetailController alloc] init];
    refundDetailVC.refundModelr = refundModel;
    [self.navigationController pushViewController:refundDetailVC animated:YES];
    
}
//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, SCREENHEIGHT - 120) Title:@"亲,您暂时还没有退货(款)订单哦～快去看看吧!" DescTitle:@"再不抢购,就卖光啦~!" BackImage:@"dingdanemptyimage" InfoStr:@"快去逛逛"];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            self.isPopToRootView = YES;
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
//        }
//    };
//}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"亲,您暂时还没有退货(款)订单哦～" DescTitle:@"再不抢购,就卖光啦~!" ButtonTitle:@"快去逛逛" Image:@"dingdanemptyimage" ReloadBlcok:^{
            self.isPopToRootView = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPopToRootView = NO;
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMRefundBaseController"];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isPopToRootView) {
        [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    }
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"JMRefundBaseController"];

}
@end













































































