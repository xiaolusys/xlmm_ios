//
//  JMFineCouponController.m
//  XLMM
//
//  Created by zhang on 16/11/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFineCouponController.h"
#import "JMFIneCouponCell.h"
#import "JMFineCouponModel.h"
#import "JMEmptyView.h"
#import "PublishNewPdtViewController.h"


@interface JMFineCouponController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JMEmptyView *empty;
/**
 *  上拉加载的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;
/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
@property (nonatomic, strong)NSString *nextPage;


@end

static NSString *FineCouponCellIdentifier = @"FineCouponCellIdentifier";

@implementation JMFineCouponController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];

}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JMFIneCouponCell class] forCellReuseIdentifier:FineCouponCellIdentifier];
    [self.view addSubview:self.tableView];
    
    
    
}
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/boutique", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self fetchFineCouponData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:self.nextPage]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextPage WithParaments:nil WithSuccess:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self fetchFineCouponData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

- (void)fetchFineCouponData:(NSDictionary *)dict {
    self.nextPage = dict[@"next"];
    NSArray *resultsArr = dict[@"results"];
    if (resultsArr.count == 0) {
        self.empty.hidden = NO;
        return ;
    }
    for (NSDictionary *dic in resultsArr) {
        JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
}

#pragma mark ---UItableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMFIneCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:FineCouponCellIdentifier];
    if (!cell) {
        cell = [[JMFIneCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FineCouponCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v1/pmt/ninepic/get_nine_pic_by_modelid");
    urlString = [NSString stringWithFormat:@"%@?model_id=%@",urlString,model.fineCouponModelID];
    PublishNewPdtViewController *pushVC = [[PublishNewPdtViewController alloc] init];
    pushVC.isPushingDays = YES;
    pushVC.pushungDaysURL = urlString;
    [self.navigationController pushViewController:pushVC animated:YES];
    
    
}


- (void)emptyView {
    kWeakSelf
    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"你的钱包空空如也" DescTitle:@"" BackImage:@"wallet" InfoStr:@"快去逛逛"];
    [self.view addSubview:empty];
    empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    self.empty = empty;
    self.empty.hidden = YES;
}








@end






































































