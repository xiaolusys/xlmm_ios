//
//  JMTotalEarningController.m
//  XLMM
//
//  Created by zhang on 17/3/2.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMTotalEarningController.h"
#import "SwipeTableView.h"
#import <objc/message.h>
#import "HMSegmentedControl.h"
#import "JMEarningRecordTableView.h"
#import "CarryLogModel.h"


@interface JMTotalEarningController () <SwipeTableViewDelegate, SwipeTableViewDataSource, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UIScrollViewDelegate> {
    NSMutableArray *_urlArray;
    NSMutableDictionary *_nextUrlDict;
    NSInteger _currentIndex;
}

@property (nonatomic, strong) SwipeTableView *swipeTableView;
@property (nonatomic, strong) STHeaderView *headerView;
@property (nonatomic, strong) HMSegmentedControl *segmentView;
@property (nonatomic, strong) JMEarningRecordTableView *recordTableView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArr;
@property (nonatomic, strong) NSMutableArray *sectionKeysArr;

//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMTotalEarningController

#pragma mark 懒加载
- (SwipeTableView *)swipeTableView {
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc] initWithFrame:self.view.bounds];
        _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _swipeTableView.dataSource = self;
        _swipeTableView.delegate = self;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderView = self.headerView;
        _swipeTableView.swipeHeaderBar = self.segmentView;
//        _swipeTableView.swipeHeaderTopInset = 0.f;
    }
    return _swipeTableView;
}
- (STHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[STHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.layer.masksToBounds = YES;
        _headerView.layer.borderColor = [UIColor lineGrayColor].CGColor;
        _headerView.layer.borderWidth = 1.f;
        UILabel *recordLabel = [UILabel new];
        recordLabel.font = [UIFont systemFontOfSize:14.];
        recordLabel.textColor = [UIColor buttonTitleColor];
        [_headerView addSubview:recordLabel];
        UILabel *valueLabel = [UILabel new];
        valueLabel.font = [UIFont systemFontOfSize:36.];
        valueLabel.textColor = [UIColor orangeColor];
        [_headerView addSubview:valueLabel];
        UILabel *descLabel = [UILabel new];
        descLabel.font = [UIFont systemFontOfSize:14.];
        descLabel.textColor = [UIColor dingfanxiangqingColor];
        [_headerView addSubview:descLabel];
        [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.top.equalTo(_headerView).offset(10);
        }];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.top.equalTo(recordLabel.mas_bottom).offset(10);
        }];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.top.equalTo(valueLabel.mas_bottom).offset(10);
        }];
        recordLabel.text = @"累计收益";
        valueLabel.text = self.earningsRecord;
        descLabel.text = [NSString stringWithFormat:@"2016.3.24号系统升级之前的收益%@",self.historyEarningsRecord];
        
    }
    return _headerView;
}
- (HMSegmentedControl *)segmentView {
    if (!_segmentView) {
        _segmentView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        _segmentView.sectionTitles = @[@"全部",@"奖金",@"返现",@"佣金"];
        _segmentView.selectedSegmentIndex = _currentIndex;
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
        _segmentView.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15.]};
        //        _segmentView.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        _segmentView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentView.selectionIndicatorHeight = 2.f;
        _segmentView.selectionIndicatorColor = [UIColor orangeColor];
        [_segmentView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentView;
}
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}
- (NSMutableArray *)tableViewDataArr {
    if (!_tableViewDataArr) {
        _tableViewDataArr = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            NSMutableArray *dic = [NSMutableArray array];
            [_tableViewDataArr addObject:dic];
        }
    }
    return _tableViewDataArr;
}

#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMTotalEarningController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMTotalEarningController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"收益记录" selecotr:@selector(backClick)];
    _urlArray = [NSMutableArray array];
    _nextUrlDict = [NSMutableDictionary dictionary];
    _currentIndex = 0;
    _urlArray = [self createRequestURL];
    [self.view addSubview:self.swipeTableView];
//    [self.swipeTableView.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.screenEdgePanGestureRecognizer];
    [self createPullFooterRefresh];
    [self loadDataUrl:_urlArray[_currentIndex]];
}
#pragma mrak 刷新界面
- (void)createPullFooterRefresh {
    //    kWeakSelf
    self.recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadMore];
    }];
}
- (void)endRefresh {
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.recordTableView.mj_footer endRefreshing];
    }
}

#pragma mark 获取固定数据处理
- (NSMutableArray *)createRequestURL {
    NSArray *urlBefroe = @[@"/rest/v2/mama/carry", @"/rest/v2/mama/awardcarry", @"/rest/v2/mama/clickcarry",
                           @"/rest/v2/mama/ordercarry"];
    for (int i = 0; i < 4; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [_urlArray addObject:url];
    }
    return _urlArray;
}

#pragma mark 网络请求,数据处理
- (void)loadDataUrl:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在加载..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    NSNumber *number = [NSNumber numberWithInteger:_currentIndex];
    NSString *url = [_nextUrlDict objectForKey:number];
    if ([NSString isStringEmpty:url]) {
        [self endRefresh];
        [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
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
- (void)dataAnalysis:(NSDictionary *)dic {
    NSNumber *currentUrlNum = [NSNumber numberWithInteger:_currentIndex];
    [_nextUrlDict setObject:dic[@"next"] forKey:currentUrlNum];
    NSArray *results = dic[@"results"];
    NSMutableArray *currentDataArr = self.tableViewDataArr[_currentIndex];
    NSMutableDictionary *currentDataDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in results) {
        CarryLogModel *model = [CarryLogModel mj_objectWithKeyValues:dict];
        NSString *date = [self dateDeal:model.date_field];
        NSMutableArray *currentArr = [[currentDataDic allKeys] mutableCopy];
        if ([currentArr containsObject:date]) {
            NSMutableArray *orderArr = [currentDataDic objectForKey:date];
            [orderArr addObject:model];
        }else {
            NSMutableArray *orderArr = [NSMutableArray array];
            [orderArr addObject:model];
            [currentDataDic setObject:orderArr forKey:date];
        }
    }
    NSArray *keysArr = [self sortAllKeyArray:[[currentDataDic allKeys] mutableCopy]];
    for (int i = 0; i < keysArr.count; i++) {
        [currentDataArr addObject:currentDataDic[keysArr[i]]];
    }
    [MBProgressHUD hideHUD];
    // 刷新 数据
    [self getDataWithIndex:_currentIndex];
    
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
    NSString *date = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return date;
}
- (void)getDataWithIndex:(NSInteger)index {
    ((void (*)(void *, SEL, NSMutableArray *, NSInteger))objc_msgSend)((__bridge void *)(self.swipeTableView.currentItemView),@selector(refreshWithData:atIndex:), self.tableViewDataArr,index);
}
#pragma mark SwipeTableView 代理
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 4;
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    JMEarningRecordTableView *tableView = (JMEarningRecordTableView *)view;
    if (!tableView) {
        tableView = [[JMEarningRecordTableView alloc] initWithFrame:swipeView.bounds style:UITableViewStyleGrouped];
    }
//    JMEarningRecordTableView * tableView = self.recordTableView;
    [tableView refreshWithData:self.tableViewDataArr atIndex:index];
    self.recordTableView = tableView;
    view = tableView;
    return view;
}
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _currentIndex = swipeView.currentItemIndex;
    [self.segmentView setSelectedSegmentIndex:_currentIndex animated:YES];
}
// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    _currentIndex = swipeView.currentItemIndex;
    NSArray *keysArr = self.tableViewDataArr[_currentIndex];
    if (keysArr.count == 0) {
        [self loadDataUrl:_urlArray[_currentIndex]];
    }
    
}
#pragma mark 点击事件处理
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    _currentIndex = segmentedControl.selectedSegmentIndex;
    [self.segmentView setSelectedSegmentIndex:_currentIndex animated:YES];
    [self.swipeTableView scrollToItemAtIndex:_currentIndex animated:NO];
//    NSArray *keysArr = [self.tableViewDataArr[_currentIndex] allKeys];
    NSArray *keysArr = self.tableViewDataArr[_currentIndex];
    if (keysArr.count == 0) {
        [self loadDataUrl:_urlArray[_currentIndex]];
    }
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end























