//
//  CSOrderListController.m
//  XLMM
//
//  Created by zhang on 17/3/14.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSOrderListController.h"
#import "SwipeTableView.h"
#import "HMSegmentedControl.h"
#import "UIView+RGSize.h"
#import "JMDataManger.h"
#import "CSCustomerTableView.h"
#import "CSCustomerColView.h"
#import "JMFineCouponModel.h"
#import <objc/message.h>

@interface CSOrderListController () <SwipeTableViewDelegate, SwipeTableViewDataSource> {
    NSArray             *_itemUrls;
    NSInteger           _currentPageIndex;
    NSMutableDictionary *_nextUrlDict;
//    BOOL                _isPullDown;
    BOOL                _isLoadMore;
}

@property (nonatomic, strong) SwipeTableView        *swipeTableView;
@property (nonatomic, strong) HMSegmentedControl    *segmentView;
@property (nonatomic, strong) CSCustomerTableView   *tableView;
@property (nonatomic, strong) NSMutableArray        *dataSource;
@property (nonatomic, strong) NSMutableDictionary   *tableViewData;


@end

@implementation CSOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"我的订单" selecotr:@selector(backClick)];
    
    [self.view addSubview:self.swipeTableView];
    
    _nextUrlDict = [NSMutableDictionary dictionary];
    _itemUrls = [[self getItemUrls] copy];
    [self loadDataSource:_itemUrls[_currentPageIndex]];
//    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
//    [self.tableView.mj_header beginRefreshing];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _currentPageIndex = currentIndex;
}
#pragma mrak 刷新界面
//- (void)createPullHeaderRefresh {
//    kWeakSelf
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _isPullDown = YES;
//        [weakSelf.tableView.mj_footer resetNoMoreData];
//        [weakSelf loadDataSource:[self getItemUrls][_currentPageIndex]];
//    }];
//}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
//    if (_isPullDown) {
//        _isPullDown = NO;
//        [self.tableView.mj_header endRefreshing];
//    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark ==== 网络请求,数据处理 ====
- (NSMutableArray *)getItemUrls {
    NSArray *urlBefroe = @[@"/rest/v2/modelproducts?cid=153", @"/rest/v2/modelproducts?cid=8", @"/rest/v2/modelproducts?cid=7",
                           @"/rest/v2/modelproducts?cid=3",@"/rest/v2/modelproducts?cid=5"];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < urlBefroe.count; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [mutArr addObject:url];
    }
    return mutArr;
}
- (NSArray *)getItemTitles {
    return @[@"奶粉尿裤",@"家居百货",@"美妆洗护",@"食品保健",@"母婴用品"];
}
- (void)loadDataSource:(NSString *)urlString {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSMutableArray *dataArr = [self.tableViewData objectForKey:@(_currentPageIndex)];
        [dataArr removeAllObjects];
        [self dataAnalysis:responseObject];
        [[JMGlobal global] hideLoading];
    } WithFail:^(NSError *error) {
        [[JMGlobal global] hideLoading];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)responseObj {
    [_nextUrlDict setObject:responseObj[@"next"] forKey:@(_currentPageIndex)];
    NSArray *results = responseObj[@"results"];
    NSMutableArray *dataArr = [self.tableViewData objectForKey:@(_currentPageIndex)];
    for (NSDictionary *dic in results) {
        JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
        [dataArr addObject:model];
    }
    [self.tableViewData setObject:[NSArray arrayWithArray:dataArr] forKey:[NSString stringWithFormat:@"%ld",_currentPageIndex]];
    [self reloadDataWithIndex:_currentPageIndex];
}
- (void)loadMore {
    NSString *url = [_nextUrlDict objectForKey:@(_currentPageIndex)];
    if ([NSString isStringEmpty:url]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
    
}


#pragma mark ==== 懒加载 ====
- (NSMutableDictionary *)tableViewData {
    if (!_tableViewData) {
        _tableViewData = [NSMutableDictionary dictionary];
        for (int i = 0; i < [[self getItemTitles] count]; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            [_tableViewData setObject:arr forKey:@(i)];
        }
    }
    return _tableViewData;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (SwipeTableView *)swipeTableView {
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc] initWithFrame:self.view.bounds];
        _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _swipeTableView.dataSource = self;
        _swipeTableView.delegate = self;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderView = nil;
        _swipeTableView.swipeHeaderBar = self.segmentView;
        _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    }
    return _swipeTableView;
}
- (HMSegmentedControl *)segmentView {
    if (!_segmentView) {
        _segmentView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.sectionTitles = [self getItemTitles];
        _segmentView.selectedSegmentIndex = _currentPageIndex;
        _segmentView.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentView.selectionIndicatorHeight = 2.f;
        _segmentView.selectionIndicatorColor = [UIColor orangeColor];
        _segmentView.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
        _segmentView.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
        [_segmentView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}


#pragma mark ==== SwipeTableView 代理 ====
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return [[self getItemTitles] count];
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    CSCustomerTableView *tableView = (CSCustomerTableView *)view;
    if (!tableView) {
        tableView = [[CSCustomerTableView alloc] initWithFrame:swipeView.bounds style:UITableViewStylePlain];
    }
    [tableView refreshWithCustomerTableViewData:self.tableViewData atIndex:index];
    self.tableView = tableView;
    view = tableView;
    return view;
}
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    [self.segmentView setSelectedSegmentIndex:swipeView.currentItemIndex animated:YES];
}
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    _currentPageIndex = swipeView.currentItemIndex;
    [self.segmentView setSelectedSegmentIndex:_currentPageIndex animated:YES];
    [self getDataSource:_currentPageIndex];
}
- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
}
- (CGFloat)swipeTableView:(SwipeTableView *)swipeTableView heightForRefreshHeaderAtIndex:(NSInteger)index {
    return 60;
}
#pragma mark ==== segmentView 点击事件, swipeTableView 移动事件
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    _currentPageIndex = segmentedControl.selectedSegmentIndex;
    [self.swipeTableView scrollToItemAtIndex:_currentPageIndex animated:NO];
    [self getDataSource:_currentPageIndex];
    
}
- (void)getDataSource:(NSInteger)index {
    NSArray *dataArr = [self.tableViewData objectForKey:[NSString stringWithFormat:@"%ld",index]];
    if (dataArr.count == 0) {
        [[JMGlobal global] showLoading:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadDataSource:_itemUrls[index]];
        });
        
//        [self.tableView.mj_header beginRefreshing];
    }
    
}
- (void)reloadDataWithIndex:(NSInteger)index {
    ((void (*)(void *, SEL, NSMutableDictionary *, NSInteger))objc_msgSend)((__bridge void *)(self.swipeTableView.currentItemView),@selector(refreshWithCustomerTableViewData:atIndex:), self.tableViewData,index);
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
























































































